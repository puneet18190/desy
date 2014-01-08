require 'pathname'

require 'mime/types'

require 'media'
require 'slide/math_images'

require 'export'
require 'export/lesson'
require 'export/lesson/scorm'
require 'export/lesson/scorm/renderer'
require 'export/lesson/shared'
require 'export/lesson/shared/scorm_and_scorm_renderer'

module Export
  module Lesson
    class Scorm
      class Renderer
        module Helper
          include Rails.application.routes.url_helpers
          
          SCORM_LOCALE         = I18n.default_locale
          SCORM_SCHOOL_LEVELS  = {}
          
          def scorm_locale
            SCORM_LOCALE
          end
          
          def scorm_school_level(school_level)
            resp = SCORM_SCHOOL_LEVELS[school_level]
            resp.nil? ? 'school' : resp
          end
          
          def scorm_slide_title(slide)
            return 'Cover' if slide.cover?
            resp = "Slide #{slide.position - 1}"
            resp = "#{resp} - #{slide.title}" if slide.title.present?
            resp
          end
          
          def scorm_slide_dependencies(slide)
            resp = "<dependency identifierref=\"common\"/>"
            resp = "#{resp}<dependency identifierref=\"tinyMCE\"/>" if [Slide::AUDIO, Slide::IMAGE1, Slide::TEXT, Slide::VIDEO1].include?(slide.kind)
            resp = "#{resp}<dependency identifierref=\"players\"/>" if [Slide::AUDIO, Slide::VIDEO1, Slide::VIDEO2].include?(slide.kind)
            resp = "#{resp}<dependency identifierref=\"documents\"/>" if slide.documents_slides.any?
            resp
          end
          
          def scorm_document_file(document) # TODO schorm sistema url documento con replace
            "
              <file href=\"html/documents/#{document.id}/#{document.url}\">
                <metadata>
                  <lom>
                    <general>
                      <identifier>
                        <catalog>URI</catalog>
                        <entry>#{document.url}</entry>
                      </identifier>
                    </general>
                    <technical>
                      <format>document/#{document.extension}</format>
                      <size>#{document.size}</size>
                      <location>#{document.url}</location>
                    </technical>
                  </lom>
                </metadata>
              </file>
            "
          end
          
          def scorm_document_general_metadata(document)
            "
              <general>
                <title>
                  <string language=\"#{scorm_locale}\">#{document.title}</string>
                </title>
                <description>
                  <string language=\"#{scorm_locale}\">#{document.description}</string>
                </description>
                <structure>
                  <source>LOMv1.0</source>
                  <value>atomic</value>
                </structure>
              </general>
            "
          end
          
          def scorm_media_element_files(media_element) # TODO schorm sistema urls con replace + estrai anche estensione, invece di mettere quella finta
            case media_element.sti_type
            when 'Video'
              return "
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.mp4_url}\">
                  #{scorm_media_element_file_metadata(media_element, 'mp4')}
                </file>
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.webm_url}\">
                  #{scorm_media_element_file_metadata(media_element, 'webm')}
                </file>
              "
            when 'Image'
              return "
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.url}\">
                  #{scorm_media_element_file_metadata(media_element, 'jpeg')}
                </file>
              "
            when 'Audio'
              return "
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.m4a_url}\">
                  #{scorm_media_element_file_metadata(media_element, 'm4a')}
                </file>
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.ogg_url}\">
                  #{scorm_media_element_file_metadata(media_element, 'ogg')}
                </file>
              "
            end
          end
          
          def scorm_media_element_file_metadata(media_element, extension) # TODO schorm sistemare i metodi url con replace + metodo size
            my_duration = (media_element.sti_type == 'Image' || extension == 'jpeg') ? '' : media_element.min_duration # TODO schorm riempi la duration con modello pagina 103, wrappalo dentro una tag apposita
            my_url = case extension
            when 'mp4'
              media_element.mp4_url
            when 'webm'
              media_element.webm_url
            when 'm4a'
              media_element.m4a_url
            when 'ogg'
              media_element.ogg_url
            when 'jpeg' # TODO schorm metti anche altre possibili estensioni
              media_element.url
            end
            "
              <metadata>
                <lom>
                  <general>
                    <identifier>
                      <catalog>URI</catalog>
                      <entry>#{my_url}</entry>
                    </identifier>
                  </general>
                  <technical>
                    <format>#{media_element.sti_type.downcase}/#{extension}</format>
                    <size>#{'123456'}</size>
                    <location>#{my_url}</location>
                    #{my_duration}
                  </technical>
                </lom>
              </metadata>
            "
          end
          
          def scorm_base_packages
            "
              <resource identifier=\"common\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <dependency identifierref=\"common_js\"/>
                <dependency identifierref=\"common_css\"/>
                <dependency identifierref=\"common_images\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
              <resource identifier=\"players\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <file href=\"html/assets/icone-player.svg\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
              <resource identifier=\"documents\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <file href=\"html/assets/documents_fondo.png\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
              <resource identifier=\"tinyMCE\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <file href=\"html/assets/pallino.svg\"/>
                <file href=\"html/assets/tiny_items.gif\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
              <resource identifier=\"common_js\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <file href=\"html/assets/lesson_export/application.js\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
              <resource identifier=\"common_css\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <file href=\"html/assets/lesson_export/application.css\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
              <resource identifier=\"common_images\" type=\"webcontent\" adlcp:scormType=\"asset\">
                <file href=\"html/assets/favicon32x32.png\"/>
                <file href=\"html/assets/lesson-editor-logo-footer.png\"/>
                <metadata>
                  <lom>
                    <general>
                      <structure>
                        <source>LOMv1.0</source>
                        <value>collection</value>
                      </structure>
                    </general>
                    #{scorm_metametadata}
                  </lom>
                </metadata>
              </resource>
            "
          end
          
        end
      end
    end
  end
end
