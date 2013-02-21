module FilenameToken

  module InstanceMethods
    def filename_token
      @filename_token ||= SecureRandom.urlsafe_base64(16)
    end

    private
    def reset_filename_token
      @filename_token = nil
    end
  end
  
  def self.included(receiver)
    receiver.send :include, InstanceMethods

    receiver.instance_eval do
      before_save :reset_filename_token
    end
  end

end