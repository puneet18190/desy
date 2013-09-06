require 'fileutils'
require 'pathname'
require 'zlib'

require 'zip'

require 'env_relative_path'

require 'export'
require 'export/lesson'

module Export
  module Lesson
    class Archive

      include EnvRelativePath

      FOLDER                               = env_relative_pathname Rails.root, 'app', 'exports', 'lessons', 'archives'
      PUBLIC_FOLDER                        = env_relative_pathname RAILS_PUBLIC, 'exports', 'lessons'
      MEDIA_ELEMENTS_UPFOLDER              = RAILS_PUBLIC
      DOCUMENTS_UPFOLDER                   = RAILS_PUBLIC
      ASSETS_ARCHIVE_MAIN_FOLDER_NAME      = 'assets'
      MATH_IMAGES_ARCHIVE_MAIN_FOLDER_NAME = 'math_images'

      # STORED or DEFLATED
      COMPRESSION_METHOD = Zip::Entry::STORED

      TIME_FORMAT = '%Y%m%d_%H%M%S_%Z_%N'

      INDEX_PAGE_NAME = 'index.html'

      def self.remove_folder!
        FileUtils.rm_rf FOLDER
      end

      def self.remove_public_folder!
        FileUtils.rm_rf PUBLIC_FOLDER
      end

      private
      attr_reader :lesson, :index, 
                  :filename_without_extension, :archive_main_folder,
                  :folder, :path,
                  :public_folder, :public_path,
                  :assets_archive_main_folder, :math_images_archive_main_folder
      public

      def initialize(lesson, index)
        @lesson, @index = lesson, index

        filename_without_extension_and_time = ''.tap do |s|
          s << lesson.id.to_s

          parameterized_title = lesson.title.parameterize

          s << "_#{parameterized_title}" if parameterized_title.present?
        end

        filename_time = lesson.updated_at.utc.strftime(TIME_FORMAT)

        @filename_without_extension      = filename_without_extension_and_time + '_' + filename_time
        @archive_main_folder             = filename_without_extension_and_time

        filename                         = "#{filename_without_extension}.zip"
        @folder                          = FOLDER.join lesson.id.to_s
        @path                            = folder.join filename

        public_filename                  = "#{filename_without_extension}.zip"
        @public_folder                   = PUBLIC_FOLDER.join lesson.id.to_s
        @public_path                     = public_folder.join public_filename

        @assets_archive_main_folder      = File.join archive_main_folder, ASSETS_ARCHIVE_MAIN_FOLDER_NAME
        @math_images_archive_main_folder = File.join archive_main_folder, MATH_IMAGES_ARCHIVE_MAIN_FOLDER_NAME
      end

      def url
        find_or_create

        "/#{public_path.relative_path_from RAILS_PUBLIC}"
      end

      def find_or_create
        return if path.exist?
        
        # raises if export assets are not compiled
        raise "Assets are not compiled. Please create them using rake exports:lessons:assets:compile" unless assets_compiled?

        folder.mkpath unless folder.exist?
        remove_other_possible_archives
        create
        
        public_folder.mkpath unless public_folder.exist?
        remove_other_possible_links
        link
      end


      private
      def link
        public_path.make_symlink path.relative_path_from(public_path.dirname)
      end

      def math_images
        lesson.slides.map{ |s| s.math_images.to_a(:with_folder) }.flatten.uniq_by{ |v| v.basename }
      end

      def assets_compiled?
        ASSETS_FOLDER.exist? && !ASSETS_FOLDER.entries.empty?
      end

      def remove_other_possible_links
        Pathname.glob(public_folder.join '*.zip').each{ |path| path.unlink }
      end

      def remove_other_possible_archives
        Pathname.glob(folder.join '*.zip').each{ |path| path.unlink }
      end

      def assets_files
        Pathname.glob ASSETS_FOLDER.join('**', '*')
      end

      def media_elements_files
        media_elements_folders = lesson.media_elements.map { |r| Pathname.new r.media.folder }
        media_elements_folders.map { |f| Pathname.glob f.join '**', '*' }.flatten
      end

      def documents_files
        documents_folders = lesson.documents.map { |r| Pathname.new r.attachment.folder }
        documents_folders.map { |f| Pathname.glob f.join '**', '*' }.flatten
      end

      def create
        with_index_tmpfile do |index_path|
          Zip::File.open(path, Zip::File::CREATE) do |archive|

            add_index_entry archive, index_path

            assets_files.each do |path|
              add_entry archive, path, assets_archive_main_folder, path.relative_path_from(ASSETS_FOLDER)
            end

            media_elements_files.each do |path|
              add_entry archive, path, archive_main_folder, path.relative_path_from(MEDIA_ELEMENTS_UPFOLDER)
            end

            documents_files.each do |path|
              add_entry archive, path, archive_main_folder, path.relative_path_from(DOCUMENTS_UPFOLDER)
            end

            math_images.each do |path|
              add_entry archive, path, math_images_archive_main_folder, path.basename
            end

          end
        end
        path.chmod 0644
      rescue => e
        path.unlink if path.exist?
        public_path.unlink if public_path.exist?
        raise e
      end

      def with_index_tmpfile
        Tempfile.open('desy') do |file|
          file.write index
          file.close
          yield file.path
        end
      end

      def add_index_entry(archive, index_path)
        add_entry archive, index_path, archive_main_folder, INDEX_PAGE_NAME
      end

      def entry_path(archive_main_folder, relative_path_from_archive_main_folder)
        File.join archive_main_folder, relative_path_from_archive_main_folder
      end

      def add_entry(archive, path, archive_main_folder, relative_path_from_archive_main_folder)
        entry = Zip::Entry.new path.to_s, entry_path(archive_main_folder, relative_path_from_archive_main_folder), '', '', 0, 0, COMPRESSION_METHOD
        archive.add entry, path
      end

    end
  end
end