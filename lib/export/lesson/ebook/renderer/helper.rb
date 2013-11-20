require 'pathname'

require 'mime/types'

require 'media'
require 'slide/math_images'

require 'export'
require 'export/lesson'
require 'export/lesson/ebook'
require 'export/lesson/shared'
require 'export/lesson/shared/ebook_and_ebook_renderer'

module Export
  module Lesson
    class Ebook
      class Renderer < ActionView::Renderer
        # TODO provare a memoizzare per vedere l'effetto che fa
        module Helper
          # TODO spostarlo in SETTINGS
          PACKAGE_ID                      = 'DESYLesson'
          DCTERMS_MODIFIED_FORMAT         = '%Y-%m-%dT%H:%M:%SZ'
          UNKNOWN_MIME_TYPE               = 'application/octet-stream'
          MEDIA_ELEMENT_MIME_TYPES        = Media::MIME_TYPES
          MATH_IMAGES_ARCHIVE_FOLDER_NAME = Shared::MATH_IMAGES_ARCHIVE_FOLDER_NAME

          include ActionView::Helpers::TranslationHelper
          include ApplicationHelper

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

          def document_fallback_title(document, position)
            "Document #{position} - #{document.title}"
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

          def document_path(document)
            document.url UrlTypes::EXPORT
          end

          def document_item_attributes(document)
            href = document_path(document)

            { id:         document_item_id(document)          ,
              href:       href                                ,
              fallback:   document_item_fallback_id(document) ,
              media_type: mime_type(href)                     }
          end

          def document_item_fallback_attributes(document)
            { id:   document_item_fallback_id(document)                     ,
              href: document_fallbacks_relative_from_content_path(document) }
          end

          def media_element_path(media_element, format = nil)
            href_method = format ? :"#{format}_url" : :url
            media_element.send href_method, UrlTypes::EXPORT
          end

          def media_element_item_attributes(media_element, lesson, format)
            id =  "#{media_element.class.to_s.downcase}_#{media_element.id}"
            id << "_#{format}" if format

            href = media_element_path(media_element, format)

            properties  = media_element.cover_of?(lesson) ? 'cover-image' : nil

            { id:         id                            ,
              href:       href                          ,
              properties: properties                    ,
              media_type: media_element_mime_type(href) }
          end

          def slide_content(slide)
            return nil unless slide.text
            
            fragment = Nokogiri::XML::DocumentFragment.parse(slide.text)
            
            fragment.css(Slide::MathImages::CSS_SELECTOR).each do |el|
              math_image_basename = File.basename CGI.parse(URI("http://www.example.com/#{el[:src]}").query)['formula'].first
              el[:src] = math_image_path_relative_from_contents_folder math_image_basename
            end
            
            fragment.to_s.html_safe
          end

          def math_image_item_id(i)
            "math_image_#{i}"
          end

          def math_image_item_href(math_image)
            math_image_path_relative_from_contents_folder math_image.basename
          end
        end
      end
    end
  end
end
