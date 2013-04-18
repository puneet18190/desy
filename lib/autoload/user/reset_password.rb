require 'securerandom'

module User::ResetPassword
  
  
  module ClassMethods
    
    def generate_password_token
      loop do
        token = SecureRandom.urlsafe_base64(16)
        break token unless where(:password_token => token).first
      end
    end
    
    def reset_password!(token)
      user = User.where(:password_token => token).first
      return nil unless user
      if self.password_token
        self.password_token = nil
        new_password = SecureRandom.urlsafe_base64(10)
        self.password = new_password
        self.password_confirmation = new_password
        self.save!
        return new_password
      end
    end
    
  end
  
  
  module InstanceMethods
    
    def password_token!
      self.password_token = self.class.generate_password_token
      self.save
    end
    
  end
  
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
  
  
end
