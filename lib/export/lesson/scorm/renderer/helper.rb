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
          
          def scorm_manifest_header(lesson)
            "
              identifier=\"desy.lesson.#{lesson.id}\"
              xmlns=\"http://www.imsglobal.org/xsd/imscp_v1p1\"
              xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\"
              xmlns:adlcp=\"http://www.adlnet.org/xsd/adlcp_v1p3\"
              xmlns:adlseq=\"http://www.adlnet.org/xsd/adlseq_v1p3\"
              xmlns:adlnav=\"http://www.adlnet.org/xsd/adlnav_v1p3\"
              xmlns:imsss=\"http://www.imsglobal.org/xsd/imsss\"
              xmlns:lom=\"http://ltsc.ieee.org/xsd/LOM\"
              xsi:schemaLocation=\"http://www.imsglobal.org/xsd/imscp_v1p1 imscp_v1p1.xsd
                                   http://www.adlnet.org/xsd/adlcp_v1p3 adlcp_v1p3.xsd
                                   http://www.adlnet.org/xsd/adlseq_v1p3 adlseq_v1p3.xsd
                                   http://www.adlnet.org/xsd/adlnav_v1p3 adlnav_v1p3.xsd
                                   http://www.imsglobal.org/xsd/imsss imsss_v1p0.xsd
                                   http://ltsc.ieee.org/xsd/LOM lom.xsd\"
            "
          end
          
          def scorm_locale
            SCORM_LOCALE
          end
          
          def scorm_tags(tags)
            resp = ''
            tags.split(',').each do |t|
              resp = "#{resp}<keyword><string language=\"#{scorm_locale}\">#{t}</string></keyword>"
            end
            resp
          end
          
          def scorm_author(author, date, type)
            "
              <contribute>
                <role>
                  <source>LOMv1.0</source>
                  <value>author</value>
                </role>
                <entity>BEGIN:VCARD&#13;&#10;VERSION:2.1&#13;&#10;FN:#{author}&#13;&#10;END:VCARD</entity>
                <date>
                  <dateTime>#{date.strftime('%Y-%m-%d')}</dateTime>
                  <description>
                    <string language=\"en\">#{type}</string>
                  </description>
                </date>
              </contribute>
            "
          end
          
          def scorm_metametadata
            '
              <metaMetadata>
                <metadataSchema>LOMv1.0</metadataSchema>
                <language>en</language>
              </metaMetadata>
            '
          end
          
          def scorm_requirements
            '
              <requirement>
                <orComposite>
                  <type>
                    <source>LOMv1.0</source>
                    <value>browser</value>
                  </type>
                  <name>
                    <source>LOMv1.0</source>
                    <value>ms-internet explorer</value>
                  </name>
                  <minimumVersion>9.0</minimumVersion>
                </orComposite>
              </requirement>
              <requirement>
                <orComposite>
                  <type>
                    <source>LOMv1.0</source>
                    <value>browser</value>
                  </type>
                  <name>
                    <source>LOMv1.0</source>
                    <value>webkit</value>
                  </name>
                </orComposite>
              </requirement>
              <requirement>
                <orComposite>
                  <type>
                    <source>LOMv1.0</source>
                    <value>browser</value>
                  </type>
                  <name>
                    <source>LOMv1.0</source>
                    <value>mozilla</value>
                  </name>
                </orComposite>
              </requirement>
              <requirement>
                <orComposite>
                  <type>
                    <source>LOMv1.0</source>
                    <value>browser</value>
                  </type>
                  <name>
                    <source>LOMv1.0</source>
                    <value>safari</value>
                  </name>
                </orComposite>
              </requirement>
              <requirement>
                <orComposite>
                  <type>
                    <source>LOMv1.0</source>
                    <value>browser</value>
                  </type>
                  <name>
                    <source>LOMv1.0</source>
                    <value>opera</value>
                  </name>
                </orComposite>
              </requirement>
            '
          end
          
          def scorm_school_level(school_level)
            resp = SCORM_SCHOOL_LEVELS[school_level]
            resp.nil? ? 'school' : resp
          end
          
          def scorm_copyrights
            "
              <rights>
                <copyrightAndOtherRestrictions>
                  <source>LOMv1.0</source>
                  <value>yes</value>
                </copyrightAndOtherRestrictions>
                <description>
                  <string language=\"en\">#{SETTINGS['application_copyright']}. For information about copyright contact Morgan S.P.A. via degli Olmetti 36</string>
                </description>
              </rights>
            "
          end
          
          def scorm_slide_title(slide)
            return 'Cover' if slide.cover?
            resp = "Slide #{slide.position - 1}"
            resp = "#{resp} - #{slide.title}" if slide.title.present?
            resp
          end
          
          def scorm_slide_metadata(slide)
            "
              <metadata>
                <lom>
                  <general>
                    <title>
                      <string language=\"#{scorm_locale}\">#{scorm_slide_title slide}</string>
                    </title>
                    <language>#{scorm_locale}</language>
                    <aggregationLevel>
                      <source>LOMv1.0</source>
                      <value>1</value>
                    </aggregationLevel>
                  </general>
                  #{scorm_metametadata}
                </lom>
              </metadata>
            "
          end
          
          def scorm_math_images(slide)
            resp = ''
            slide.math_images.each do |mi|
              resp = "#{resp}<file href=\"html/math_images/#{mi.code}.png\"/>" # TODO schorm farlo sul serio
            end
            resp
          end
          
          def scorm_slide_dependencies(slide)
            resp = "<dependency identifierref=\"common\"/>"
            resp = "#{resp}<dependency identifierref=\"tinyMCE\"/>" if [Slide::AUDIO, Slide::IMAGE1, Slide::TEXT, Slide::VIDEO1].include?(slide.kind)
            resp = "#{resp}<dependency identifierref=\"players\"/>" if [Slide::AUDIO, Slide::VIDEO1, Slide::VIDEO2].include?(slide.kind)
            resp = "#{resp}<dependency identifierref=\"documents\"/>" if slide.documents_slides.any?
            resp
          end
          
          def scorm_document_file(document) # TODO schorm sistema url documento
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
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          
          # TODO giunto qui
          
          def scorm_media_element_file_metadata(media_element, extension) # TODO sistemare i metodi url
            my_duration = (media_element.sti_type == 'Image' || extension == 'jpeg') ? '' : media_element.min_duration
            my_url = case extension # TODO mancano le thumb etc etc -- il cambio va esteso alla chiamata di tale metodo in caso di image oppure video!!!
            when 'mp4'
              media_element.mp4_url
            when 'webm'
              media_element.webm_url
            when 'm4a'
              media_element.m4a_url
            when 'ogg'
              media_element.ogg_url
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
                    <size>#{media_element.size}</size>
                    <location>#{my_url}</location>
                    #{my_duration}
                  </technical>
                </lom>
              </metadata>
            "
          end
          
          def scorm_media_element_files(media_element) # TODO ricontrollarne i metodi e riempire quelli che mancano
            case media_element.sti_type
            when 'Video'
              return "
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.mp4_url.gsub('bla', '')}\">
                  #{scorm_media_element_file_metadata(media_element, 'mp4')}
                </file>
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.mp4_url.gsub('bla', '')}\">
                  #{scorm_media_element_file_metadata(media_element, 'webm')}
                </file>
              "
            when 'Image'
              return "
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.mp4_url.gsub('bla', '')}\">
                  #{scorm_media_element_file_metadata(media_element, 'jpeg')}
                </file>
              "
            when 'Audio'
              return "
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.mp4_url.gsub('bla', '')}\">
                  #{scorm_media_element_file_metadata(media_element, 'm4a')}
                </file>
                <file href=\"html/media_elements/videos/#{media_element.id}/#{media_element.mp4_url.gsub('bla', '')}\">
                  #{scorm_media_element_file_metadata(media_element, 'ogg')}
                </file>
              "
            end
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
