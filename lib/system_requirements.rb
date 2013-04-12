module Desy
  # Lists the DeSY components dependencies per operative system. 
  # Used by +script/system_requirements_install+
  SYSTEM_REQUIREMENTS = {
    debian: {
      application: %w( g++ libsqlite3-dev libpq-dev ),
      media:       %w( imagemagick libav-tools libavcodec-extra-53 mkvtoolnix sox )
    }
  }

  SYSTEM_REQUIREMENTS[:ubuntu] = SYSTEM_REQUIREMENTS[:debian]
end