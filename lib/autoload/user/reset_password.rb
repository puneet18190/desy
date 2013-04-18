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
      if user.password_token
        user.password_token = nil
        new_password = SecureRandom.urlsafe_base64(10)
        user.password = new_password
        user.password_confirmation = new_password
        user.save!
        return [new_password, user]
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
