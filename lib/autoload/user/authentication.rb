require 'bcrypt'

module User::Authentication

  PEPPER_PATH = Rails.root.join('config/pepper')
  PEPPER      = (PEPPER_PATH.exist? and PEPPER_PATH.read.chomp) or (
    warn "The file #{PEPPER_PATH} does not exists or is empty."
    warn "Generating a new pepper and writing to #{PEPPER_PATH}; this will invalidate the previous user passwords."
    
    require 'securerandom'
    SecureRandom.hex(64).tap{ |token| PEPPER_PATH.open('w'){ |io| io.write token } }
  )

  COST = 10

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
