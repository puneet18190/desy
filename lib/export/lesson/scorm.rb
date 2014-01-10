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
      include EnvRelativePath
      include Shared
      
      OUTPUT_FOLDER                         = env_relative_pathname Rails.public_pathname, 'lessons', 'exports', 'scorms'
      
      INPUT_FOLDER                          = Lesson::FOLDER.join 'scorms'
      INPUT_ASSETS_FOLDER                   = INPUT_FOLDER.join 'assets'
      INPUT_VIEWS_FOLDER                    = View::FOLDER
      INPUT_VIEWS_STATIC_FILES_FOLDER       = INPUT_VIEWS_FOLDER.join 'static'
      
      FILE_HTML_FOLDER_RELATIVE_PATH        = 'html'
      FILE_MANIFEST_RELATIVE_PATH           = 'imsmanifest.xml'
      FILE_ASSETS_FOLDER_RELATIVE_PATH      = FILE_HTML_FOLDER_NAME.join 'assets'
      FILE_MATH_IMAGES_FOLDER_RELATIVE_PATH = FILE_HTML_FOLDER_NAME.join 'math_images'
      
      COMPRESSION_METHOD                    = Zip::Entry::STORED
      
      def self.remove_folder!
        FileUtils.rm_rf OUTPUT_FOLDER
      end
      
      attr_reader :lesson, :rendered_slides, :output_folder, :filename, :output_path, :file_root_folder,
                  :file_html_folder, :file_assets_folder, :file_math_images_folder
      
      def initialize(lesson, rendered_slides)
        @lesson, @rendered_slides  = lesson, rendered_slides
        parameterized_title        = lesson.title.parameterize
        filename_without_extension = lesson.id.to_s.tap{ |s| s << "_#{parameterized_title}" if parameterized_title.present? } << '.scorm'
        @output_folder             = OUTPUT_FOLDER.join lesson.id.to_s, lesson.updated_at.utc.strftime(WRITE_TIME_FORMAT)
        @filename                  = "#{filename_without_extension}.zip"
        @output_path               = output_folder.join filename
        @file_root_folder          = Pathname filename_without_extension
        @file_html_folder          = file_root_folder.join FILE_HTML_FOLDER_RELATIVE_PATH
        @file_assets_folder        = file_root_folder.join FILE_ASSETS_FOLDER_RELATIVE_PATH
        @file_math_images_folder   = file_root_folder.join FILE_MATH_IMAGES_FOLDER_RELATIVE_PATH
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
          add_string_entry file, View.instance.render({template: 'imsmanifest.xml.erb', locals: {lesson: lesson})
#          rendered_slides.each do |slide_id, rendered_slide|
#            add_string_entry file, rendered_slide, scorm_html_folder.join("slide#{slide_id}.html")
#          end
#          assets_files.each do |path|
#            add_path_entry file, path, assets_scorm_folder.join(path.relative_path_from ASSETS_FOLDER)
#          end
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
