module ScormHelper
  
  def scorm_locale
    'en' # TODO
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
  
end
