module EnvRelativePath
  module ClassMethods
    # Path scoped in a folder named `Rails.env` unless the env is production
    # Example: env_relative_path('log/media/video/editing/conversions')
    #   Rails.env == development: 'log/media/video/editing/conversions/development'
    #   Rails.env == production:  'log/media/video/editing/conversions'
    def env_relative_path(*paths)
      File.join(Rails.env.production? ? paths : paths + [Rails.env])
    end
  end
  
  def self.included(receiver)
    receiver.extend ClassMethods
  end
end
