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
    class Archive

      include EnvRelativePath
      include Shared

      FOLDER                     = env_relative_pathname Rails.public_pathname, 'lessons', 'exports', 'archives'
      
      ASSETS_FOLDER              = Lesson::FOLDER.join 'archives', 'assets'
      ASSETS_ARCHIVE_FOLDER_NAME = 'assets'

      # STORED or DEFLATED
      COMPRESSION_METHOD = Zip::Entry::STORED

      INDEX_PAGE_NAME = 'index.html'

      def self.remove_folder!
        FileUtils.rm_rf FOLDER
      end

      attr_reader :lesson, :index_page, 
                  :filename_without_extension, :folder, :filename, :archive_root_folder, :path, :assets_archive_folder, :math_images_archive_folder

      # index_page: String
      def initialize(lesson, index_page)
        @lesson, @index_page = lesson, index_page

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
        raise "Assets are not compiled. Please create them using rake exports:lessons:archives:assets:compile" unless assets_compiled?

        remove_old_files if folder.exist?
        folder.mkpath
        create

        self
      end

      private

      def assets_compiled?
        ASSETS_FOLDER.exist? && !ASSETS_FOLDER.entries.empty?
      end

      def assets_files
        Pathname.glob ASSETS_FOLDER.join('**', '*')
      end

      def create
        Zip::File.open(path, Zip::File::CREATE) do |archive|
          add_string_entry archive, index_page, archive_root_folder.join(INDEX_PAGE_NAME)

          assets_files.each do |path|
            add_path_entry archive, path, assets_archive_folder.join(path.relative_path_from ASSETS_FOLDER)
          end

          media_elements_files(exclude_versions: [ :thumb, :cover ]).each do |path|
            add_path_entry archive, path, archive_root_folder.join(path.relative_path_from MEDIA_ELEMENTS_UPFOLDER)
          end

          documents_files.each do |path|
            add_path_entry archive, path, archive_root_folder.join(path.relative_path_from DOCUMENTS_UPFOLDER)
          end

          math_images.each do |path|
            add_path_entry archive, path, math_images_archive_folder.join(path.basename)
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
