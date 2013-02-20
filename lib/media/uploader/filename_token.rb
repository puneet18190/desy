require 'media'
require 'media/uploader'
require 'securerandom'

module Media
  class Uploader
    module FilenameToken
      def generate_filename_token
        @filename_token ||= SecureRandom.urlsafe_base64(16)
      end
    end
  end
end