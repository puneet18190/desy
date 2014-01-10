require 'fileutils'
require 'pathname'
require 'zlib'
require 'zip'
require 'env_relative_path'
require 'export'
require 'export/lesson'
require 'export/lesson/shared'

module Export
  
  module Lesson
    
    class Scorm
      require 'export/lesson/scorm/view'
      
      include EnvRelativePath
      include Shared
      
      OUTPUT_FOLDER                   = env_relative_pathname Rails.public_pathname, 'lessons', 'exports', 'scorms'
      
      INPUT_FOLDER                    = Lesson::FOLDER.join 'scorms'
      INPUT_ASSETS_FOLDER             = INPUT_FOLDER.join 'assets'
      INPUT_VIEWS_FOLDER              = View::FOLDER
      INPUT_VIEWS_STATIC_FILES_FOLDER = INPUT_VIEWS_FOLDER.join 'static'
      
      FILE_ROOT_FOLDER                = Pathname '.'
      FILE_HTML_FOLDER                = FILE_ROOT_FOLDER.join 'html'
      FILE_MANIFEST                   = FILE_ROOT_FOLDER.join 'imsmanifest.xml'
      FILE_ASSETS_FOLDER              = FILE_HTML_FOLDER.join 'assets'
      FILE_MATH_IMAGES_FOLDER         = FILE_HTML_FOLDER.join 'math_images'
      
      COMPRESSION_METHOD              = Zip::Entry::STORED
      
      def self.remove_folder!
        FileUtils.rm_rf OUTPUT_FOLDER
      end
      
      attr_reader :lesson, :rendered_slides, :output_folder, :filename, :output_path
      
      def initialize(lesson, rendered_slides)
        @lesson, @rendered_slides  = lesson, rendered_slides
        parameterized_title        = lesson.title.parameterize
        filename_without_extension = lesson.id.to_s.tap{ |s| s << "_#{parameterized_title}" if parameterized_title.present? } << '.scorm'
        @output_folder             = OUTPUT_FOLDER.join lesson.id.to_s, lesson.updated_at.utc.strftime(WRITE_TIME_FORMAT)
        @filename                  = "#{filename_without_extension}.zip"
        @output_path               = output_folder.join filename
      end
      
      def url
        find_or_create
        "/#{output_path.relative_path_from Rails.public_pathname}"
      end
      
      def find_or_create
        return if output_path.exist?
        raise "Assets are not compiled. Please create them using rake exports:lessons:scorms:assets:compile" unless assets_compiled?
        remove_old_files if output_folder.exist?
        output_folder.mkpath
        create
      end
      
      private
      
      def assets_compiled?
        INPUT_ASSETS_FOLDER.exist? && INPUT_ASSETS_FOLDER.entries.present?
      end
      
      def assets_files
        Pathname.glob INPUT_ASSETS_FOLDER.join('**', '*')
      end
      
      def create
        Zip::File.open(output_path, Zip::File::CREATE) do |file|
          add_string_entry file, View.instance.render({template: 'imsmanifest.xml.erb', locals: {lesson: lesson}}), FILE_MANIFEST
          Pathname.glob(INPUT_VIEWS_STATIC_FILES_FOLDER.join('*')).each do |path|
            add_path_entry file, path, FILE_ROOT_FOLDER.join(path.basename)
          end
          rendered_slides.each do |slide_id, rendered_slide|
            add_string_entry file, rendered_slide, FILE_HTML_FOLDER.join("slide#{slide_id}.html")
          end
          assets_files.each do |path|
            add_path_entry file, path, FILE_ASSETS_FOLDER.join(path.relative_path_from INPUT_ASSETS_FOLDER)
          end
#          media_elements_files.each do |path|
#            add_path_entry file, path, scorm_html_folder.join(path.relative_path_from MEDIA_ELEMENTS_UPFOLDER)
#          end
#          documents_files.each do |path|
#            add_path_entry file, path, scorm_html_folder.join(path.relative_path_from DOCUMENTS_UPFOLDER)
#          end
#          math_images.each do |path|
#            add_path_entry file, path, math_images_folder.join(path.basename)
#          end
        end
        output_path.chmod 0644
      rescue
        output_path.unlink if output_path.exist?
        raise
      end
      
    end
    
  end
  
end
