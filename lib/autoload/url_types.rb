require 'pathname'

module UrlTypes

  EXPORT = :export

  module InstanceMethods

    private

    def url_by_url_type(url, url_type)
      case url_type

      when EXPORT
        Pathname(url).relative_path_from(Pathname('/')).to_s
      else
        url
      end
    end

  end

  def self.included(receiver)
    receiver.send :include, InstanceMethods
  end
  
  extend InstanceMethods
  singleton_class.send :public, :url_by_url_type
  
end
