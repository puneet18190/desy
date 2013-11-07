require 'securerandom'

# Provides the User logics for upgrading a user with trial account
module User::UpgradeTrial
  
  # Module containing the class methods
  module ClassMethods
    
    # Generates the token to upgrade a trial account
    def generate_upgrade_trial_token
      loop do
        token = SecureRandom.urlsafe_base64(16)
        break token unless where(:upgrade_trial_token => token).first
      end
    end
    
    # Upgrades to trial the user's account
    def upgrade_trial!(token)
      user = active.not_confirmed.where(:upgrade_trial_token => token).first
      return nil unless user
      user.confirmed = true
      user.save
    end
    
  end
  
  # Module containing the instance methods
  module InstanceMethods
    
    # Sets the upgrade trial token using the automatic generator
    def upgrade_trial_token!
      self.upgrade_trial_token = self.class.generate_upgrade_trial_token
      self.save!
    end
    
  end
  
  # Initializes the methods
  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
  
  
end
