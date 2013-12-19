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
    class Ebook
      require 'export/lesson/ebook/view'
      require 'export/lesson/shared/ebook_and_ebook_view'

      include EnvRelativePath
      include Shared
      include Shared::EbookAndEbookView

      FOLDER               = env_relative_pathname Rails.public_pathname, 'lessons', 'exports', 'ebooks'
      SLIDES_INCLUDES      = [ :media_elements_slides, :media_elements ]
      SLIDES_EAGER_LOAD    = SLIDES_INCLUDES
      SLIDES_ORDER         = 'slides.position'
      CONTENTS_FOLDER_NAME = Pathname 'OEBPS'
      EBOOK_ASSETS_FOLDER  = CONTENTS_FOLDER_NAME.join 'assets'

      VIEW_FOLDER = View::FOLDER

      ASSETS_FOLDER = Lesson::FOLDER.join 'ebooks', 'assets'
      ASSETS_PATHS  = %W( lesson_ebook/application.css )

      # STORED or DEFLATED
      COMPRESSION_METHOD = Zip::Entry::STORED

      def self.remove_folder!
        FileUtils.rm_rf FOLDER
      end

      attr_reader :lesson, :slides_without_cover, :cover_slide, :filename_without_extension, :folder, :filename, :path

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

        "/#{path.relative_path_from Rails.public_pathname}"
      end

      def find_or_create
        return if path.exist?
        
        # raises if export assets are not compiled
        raise "Assets are not compiled. Please create them using rake exports:lessons:ebooks:assets:compile" unless assets_compiled?

        remove_old_files if folder.exist?
        folder.mkpath
        create

        self
      end

      private

      def create
        Zip::File.open(path, Zip::File::CREATE) do |archive|
          add_path_entry archive, view_path('mimetype'), 'mimetype'

          add_path_entry archive, view_path('META-INF/container.xml'), 'META-INF/container.xml'

          locals = { lesson: lesson, slides_without_cover: slides_without_cover, cover_slide: cover_slide }

          add_template archive, locals.merge(math_images: math_images), CONTENTS_FOLDER_NAME.join('package.opf')

          assets_files.each do |path|
            add_path_entry archive, path, EBOOK_ASSETS_FOLDER.join(File.basename path.relative_path_from ASSETS_FOLDER)
          end

          add_template archive, locals, CONTENTS_FOLDER_NAME.join('toc.xhtml')

          add_template archive, locals, CONTENTS_FOLDER_NAME.join('cover.xhtml')

          slides_without_cover.each_with_object(CONTENTS_FOLDER_NAME.join 'slide.xhtml') do |slide, slide_view_path|
            add_template archive, { slide: slide }, CONTENTS_FOLDER_NAME.join(slide_filename slide), slide_view_path
          end

          media_elements_files(exclude_versions: [ :thumb ]).each do |path|
            add_path_entry archive, path, CONTENTS_FOLDER_NAME.join(path.relative_path_from MEDIA_ELEMENTS_UPFOLDER)
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

      def assets_compiled?
        ASSETS_FOLDER.exist? && ASSETS_FOLDER.entries.present?
      end

      def assets_files
        Pathname.glob( ASSETS_FOLDER.join('**', '*') ).reject{ |path| path.directory? }
      end

      def add_template(archive, locals, archive_entry_path, view_path_relative_from_template_folder = nil)
        view_path_relative_from_template_folder ||= archive_entry_path

        add_string_entry archive                                                                                 ,
                         View.instance.render(template: view_path_relative_from_template_folder, locals: locals) ,
                         archive_entry_path
      end

      def view_path(path)
        VIEW_FOLDER.join path
      end

    end
  end
end

