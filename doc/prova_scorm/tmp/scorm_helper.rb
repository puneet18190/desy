module ScormHelper
  
  def scorm_locale
    'en' # TODO estrarlo in modo migliore
  end
  
  def scorm_author(author, date)
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
          <string language=\"en\">Date of last modification</string>
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
    'school' # TODO mapparlo in qualche modo
  end
  
  def scorm_tags(tags)
    resp = ''
    tags.split(',').each do |t|
      resp = "#{resp}<keyword><string language=\"#{scorm_locale}\">#{t}</string></keyword>"
    end
    resp
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
  
end
