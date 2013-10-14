require 'fileutils'
require 'pathname'
require 'zlib'

require 'zip'

require 'env_relative_path'

require 'export'
require 'export/lesson'
require 'export/lesson/shared/archive_and_ebook'

module Export
  module Lesson
    class Ebook
      require 'export/lesson/ebook/renderer'
      require 'export/lesson/shared/ebook_and_ebook_renderer'

      include EnvRelativePath
      include Shared::ArchiveAndEbook
      include Shared::EbookAndEbookRenderer

      FOLDER               = env_relative_pathname RAILS_PUBLIC, 'lessons', 'exports', 'ebooks'
      SLIDES_INCLUDES      = [ :documents_slides, :documents, :media_elements_slides, :media_elements ]
      SLIDES_EAGER_LOAD    = SLIDES_INCLUDES
      SLIDES_ORDER         = 'slides.position'
      CONTENTS_FOLDER_NAME = Pathname 'OEBPS'

      # STORED or DEFLATED
      COMPRESSION_METHOD = Zip::Entry::STORED

      def self.remove_folder!
        FileUtils.rm_rf FOLDER
      end

      private
      attr_reader :lesson, :slides_without_cover, :cover_slide, :filename_without_extension, :folder, :filename, :path
      public

      def initialize(lesson)
        @lesson               = lesson
        @slides_without_cover = @lesson.slides.includes(SLIDES_INCLUDES).eager_load(SLIDES_EAGER_LOAD).order(SLIDES_ORDER)
        @cover_slide          = @slides_without_cover.shift # @slides_without_cover includes cover slide till now

        parameterized_title = lesson.title.parameterize
        time                = lesson.updated_at.utc.strftime(WRITE_TIME_FORMAT)

        @filename_without_extension = lesson.id.to_s.tap{ |s| s << "_#{parameterized_title}" if parameterized_title.present? }
        @folder                     = FOLDER.join lesson.id.to_s, time
        @filename                   = "#{filename_without_extension}.epub"
        @path                       = folder.join filename
      end

      def url
        find_or_create

        "/#{path.relative_path_from RAILS_PUBLIC}"
      end

      def find_or_create
        return if path.exist?
        
        remove_other_possible_files if folder.exist?
        folder.mkpath
        create
      end

      def create
        Zip::File.open(path, Zip::File::CREATE) do |archive|
          add_path_entry archive, template_path('mimetype'), 'mimetype'

          add_path_entry archive, template_path('META-INF/container.xml'), 'META-INF/container.xml'

          locals = { lesson: lesson, slides_without_cover: slides_without_cover, cover_slide: cover_slide }

          add_template archive, locals.merge(math_images: math_images), CONTENTS_FOLDER_NAME.join('lesson.opf')

          add_template archive, locals, CONTENTS_FOLDER_NAME.join('toc.xhtml')

          add_template archive, locals, CONTENTS_FOLDER_NAME.join('cover.xhtml')

          slide_template_path = CONTENTS_FOLDER_NAME.join('slide.xhtml')
          slides_without_cover.each do |slide|
            add_template archive, { slide: slide }, CONTENTS_FOLDER_NAME.join(slide_filename slide), slide_template_path
          end

          media_elements_files(exclude_versions: [ :thumb ]).each do |path|
            add_path_entry archive, path, CONTENTS_FOLDER_NAME.join(path.relative_path_from MEDIA_ELEMENTS_UPFOLDER)
          end

          documents_files.each do |path|
            add_path_entry archive, path, CONTENTS_FOLDER_NAME.join(path.relative_path_from DOCUMENTS_UPFOLDER)
          end

          document_fallback_template_path = CONTENTS_FOLDER_NAME.join('documents/fallback.xhtml')
          lesson.documents.each_with_index do |document, i|
            add_template archive, { document: document, position: i+1 }, CONTENTS_FOLDER_NAME.join(document_fallbacks_relative_from_content_path document), document_fallback_template_path
          end

          math_images.each do |path|
            add_path_entry archive, path, CONTENTS_FOLDER_NAME.join(math_image_path_relative_from_contents_folder path.basename)
          end
        end

        path.chmod 0644
      rescue
        path.unlink if path.exist?
        raise
      end

      private

      def add_template(archive, locals, archive_entry_path, template_path_relative_from_template_folder = nil)
        template_path_relative_from_template_folder ||= archive_entry_path

        options = { template: template_path_relative_from_template_folder, locals: locals }

        add_string_entry archive, VIEW_RENDERER.render_with_default_context(options), archive_entry_path
      end

      def template_path(path)
        TEMPLATES_FOLDER.join path
      end

    end
  end
end

