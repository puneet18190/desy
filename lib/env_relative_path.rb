module EnvRelativePath
  module ClassMethods
    # Path scoped in a folder named `Rails.env` unless the env is production
    # Example: env_relative_path('log/media_editing/video/conversions')
    #   Rails.env == development: 'log/media_editing/video/conversions/development'
    #   Rails.env == production:  'log/media_editing/video/conversions'
    def env_relative_path(path)
      Rails.env.production? ? path : File.join(path, Rails.env)
    end
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
