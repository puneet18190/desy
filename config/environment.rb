# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Desy::Application.initialize!

class ActiveRecord::Base
  
  def self.errors_path
    my_class = self.new.class.to_s
    my_class_path = my_class.gsub(/::/, '/').gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr("-", "_").downcase
    "activerecord.errors.models.#{my_class_path}"
  end
  
  def get_base_error
    self.errors.messages.has_key?(:base) ? self.errors.messages[:base].first : ''
  end
  
end
