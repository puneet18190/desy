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
      require 'export/lesson/scorm/renderer'
      require 'export/lesson/shared/scorm_and_scorm_renderer'

      include EnvRelativePath
      include Shared

      ASSETS_FOLDER              = Lesson::FOLDER.join 'scorms', 'assets'
      FOLDER                     = env_relative_pathname Rails.public_pathname, 'lessons', 'exports', 'scorms'
      ASSETS_ARCHIVE_FOLDER_NAME = 'assets'

      # STORED or DEFLATED
      COMPRESSION_METHOD = Zip::Entry::STORED

      INDEX_PAGE_NAME = 'index.html'

      def self.remove_folder!
        FileUtils.rm_rf FOLDER
      end

      private
      attr_reader :lesson, :rendered_slides, :filename_without_extension, :folder, :filename, :archive_root_folder, :path
      public

      def initialize(lesson, rendered_slides)
        @lesson, @rendered_slides = lesson, rendered_slides

        parameterized_title = lesson.title.parameterize
        time                = lesson.updated_at.utc.strftime(WRITE_TIME_FORMAT)

        @filename_without_extension = lesson.id.to_s.tap{ |s| s << "_#{parameterized_title}" if parameterized_title.present? }
        @folder                     = FOLDER.join lesson.id.to_s, time
        @filename                   = "#{filename_without_extension}.zip"
        @path                       = folder.join filename
        @archive_root_folder        = Pathname filename_without_extension
        @assets_archive_folder      = archive_root_folder.join ASSETS_ARCHIVE_FOLDER_NAME
        @math_images_archive_folder = archive_root_folder.join MATH_IMAGES_ARCHIVE_FOLDER_NAME
      end

      def url
        find_or_create

        "/#{path.relative_path_from Rails.public_pathname}"
      end

      def find_or_create
        return if path.exist?
        
        # raises if export assets are not compiled
#        raise "Assets are not compiled. Please create them using rake exports:lessons:scorms:assets:compile" unless assets_compiled?

        remove_old_files if folder.exist?
        folder.mkpath
        create
      end
      

      private

      def assets_compiled?
        ASSETS_FOLDER.exist? && ASSETS_FOLDER.entries.present?
      end

      def assets_files
        Pathname.glob ASSETS_FOLDER.join('**', '*')
      end

      def create
        Zip::File.open(path, Zip::File::CREATE) do |scorm|
#          add_string_entry scorm, index_page, archive_root_folder.join(INDEX_PAGE_NAME)

#          assets_files.each do |path|
#            add_path_entry scorm, path, assets_archive_folder.join(path.relative_path_from ASSETS_FOLDER)
#          end

          media_elements_files.each do |path|
            add_path_entry scorm, path, archive_root_folder.join(path.relative_path_from MEDIA_ELEMENTS_UPFOLDER)
          end

          documents_files.each do |path|
            add_path_entry scorm, path, archive_root_folder.join(path.relative_path_from DOCUMENTS_UPFOLDER)
          end

          math_images.each do |path|
            add_path_entry scorm, path, math_images_archive_folder.join(path.basename)
          end
        end

        path.chmod 0644
      rescue
        path.unlink if path.exist?
        raise
      end

    end
  end
end
