require 'securerandom'

module User::Confirmation

  module ClassMethods
    def generate_confirmation_token
      # Generate a token by looping and ensuring does not already exist.
      loop do
        token = SecureRandom.urlsafe_base64(16)
        break token unless where(confirmation_token: token).first
      end
    end

    def confirm!(token)
      user = User.active.not_confirmed.where(confirmation_token: token).first
      return nil unless user
      user.confirmed = true
      user.save
    end
  end
  
  module InstanceMethods
    def confirmation_token!
      if confirmed?
        self.confirmation_token = nil
      else
        self.confirmation_token = self.class.generate_confirmation_token unless confirmation_token
      end
      true
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.instance_eval do
      before_save :confirmation_token!
    end
  end
end
