require 'export'
require 'export/lesson'
require 'export/lesson/shared'

module Export
  module Lesson
    module Shared
      module ArchiveAndEbook

        MEDIA_ELEMENTS_UPFOLDER         = RAILS_PUBLIC
        DOCUMENTS_UPFOLDER              = RAILS_PUBLIC
        MATH_IMAGES_ARCHIVE_FOLDER_NAME = 'math_images'

        def media_elements_files(options = {})
          exclude_versions = options[:exclude_versions] || []
          lesson.media_elements.map{ |r| r.media.paths.reject{ |k| exclude_versions.include?(k) }.values.map{ |v| Pathname(v) } }.flatten
        end

        def documents_files
          lesson.documents.map{ |r| Pathname r.attachment.file.path }
        end

        def math_images
          lesson.slides.map{ |r| r.math_images.to_a(:with_folder) }.flatten.uniq_by{ |v| v.basename }
        end

        def add_path_entry(archive, path, entry_path)
          entry = Zip::Entry.new path.to_s, entry_path.to_s, '', '', 0, 0, self.class::COMPRESSION_METHOD
          archive.add entry, path
        end

        def add_string_entry(archive, string, entry_path)
          entry = Zip::Entry.new archive.name, entry_path.to_s, '', '', 0, 0, self.class::COMPRESSION_METHOD
          archive.get_output_stream(entry) { |f| f.print string }
        end

      end
    end
  end
end