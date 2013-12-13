require 'pathname'

require 'mime/types'

require 'media'
require 'slide/math_images'

require 'export'
require 'export/lesson'
require 'export/lesson/ebook'
require 'export/lesson/ebook/view'
require 'export/lesson/shared'
require 'export/lesson/shared/ebook_and_ebook_view'

module Export
  module Lesson
    class Ebook
      class View
        module Helper

          # TODO spostarlo in SETTINGS
          PACKAGE_ID                      = 'DESYLesson'
          DCTERMS_MODIFIED_FORMAT         = '%Y-%m-%dT%H:%M:%SZ'
          UNKNOWN_MIME_TYPE               = 'application/octet-stream'
          MEDIA_ELEMENT_MIME_TYPES        = Media::MIME_TYPES
          MATH_IMAGES_ARCHIVE_FOLDER_NAME = Shared::MATH_IMAGES_ARCHIVE_FOLDER_NAME

          include ApplicationHelper

          require 'export/lesson/shared/ebook_and_ebook_view'
          include Shared::EbookAndEbookView

          def package_id
            PACKAGE_ID
          end

          def render_slide(slide, locals = {})
            render partial: "lesson_viewer/slides/#{slide.kind}",
                   locals:  { slide: slide }.merge(locals)
          end

          def stylesheet_path
            File.join 'assets', File.basename( ASSETS_PATHS.find { |path| File.extname(path) == '.css' } )
          end

          def dcterms_modified(lesson)
            lesson.updated_at.utc.strftime DCTERMS_MODIFIED_FORMAT
          end

          def slide_path(slide)
            slide_filename slide
          end

          def slide_title(slide)
            title =  "Slide #{slide.position-1}"
            title << " - #{slide.title}" if slide.title.present?
            title
          end

          def image_path(image)
            image.url UrlTypes::EXPORT
          end

          def cover_image_path(cover_slide)
            media_element = cover_slide.media_elements_slides.first.try(:media_element)
            return nil unless media_element
            image_path media_element
          end

          def media_element_mime_type(path)
            MEDIA_ELEMENT_MIME_TYPES.fetch(File.extname(path)) { mime_type(path) }
          end

          def mime_type(path)
            MIME::Types.of(path.to_s).first.try(:content_type) || UNKNOWN_MIME_TYPE
          end

          def media_element_path(media_element, format = nil)
            href_method = format ? :"#{format}_url" : :url
            media_element.send href_method, UrlTypes::EXPORT
          end

          def media_element_item_attributes(media_element, lesson, format)
            id =  "#{media_element.class.to_s.downcase}_#{media_element.id}"
            id << "_#{format}" if format

            href = media_element_path media_element, format

            properties = media_element.cover_of?(lesson) ? 'cover-image' : nil

            { id:         id                            ,
              href:       href                          ,
              properties: properties                    ,
              media_type: media_element_mime_type(href) }
          end

          def slide_content(slide)
            slide.text(math_images_path_relative_from_folder: math_images_archive_folder_name)
          end

          def math_image_item_id(i)
            "math_image_#{i}"
          end

          def math_images_archive_folder_name
            self.class::MATH_IMAGES_ARCHIVE_FOLDER_NAME
          end

          def math_image_item_href(math_image)
            math_image_path_relative_from_contents_folder math_image.basename
          end
        end
      end
    end
  end
end
