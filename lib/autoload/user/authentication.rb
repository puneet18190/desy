require 'bcrypt'

module User::Authentication

  PEPPER = '3e0e6d5ebaa86768a0a51be98fce6367e44352d31685debf797b9f6ccb7e2dd0f5139170376240945fcfae8222ff640756dd42645336f8b56cdfe634144dfa7d'
  COST   = 10

  module ClassMethods
    def authenticate(email, password)
      return false if email.blank? || password.blank?
      user = active.confirmed.where(email: email).first
      # and user: in order to return the user
      user.try(:valid_password?, password) and user
    end

    # constant-time comparison algorithm to prevent timing attacks
    def secure_compare(a, b)
      return false if a.blank? || b.blank? || a.bytesize != b.bytesize
      l = a.unpack "C#{a.bytesize}"

      res = 0
      b.each_byte { |byte| res |= byte ^ l.shift }
      res == 0
    end
  end
  
  module InstanceMethods
    def encrypt_password
      if password and !password.empty?
        self.encrypted_password = BCrypt::Password.create("#{password}#{PEPPER}", cost: COST).to_s
      end
      true
    end

    def valid_password?(password)
      bcrypt = BCrypt::Password.new(encrypted_password)
      password = BCrypt::Engine.hash_secret("#{password}#{PEPPER}", bcrypt.salt)
      self.class.secure_compare(password, encrypted_password)
    end
    
    def clear_password_and_password_confirmation
      self.password = nil
      self.password_confirmation = nil
    end
  end
  
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods

    receiver.instance_eval do
      before_save :encrypt_password
      after_save  :clear_password_and_password_confirmation
    end
  end
end
