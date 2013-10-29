# Regular mailer
class UserMailer < ActionMailer::Base
  
  include MailerHelper
  helper MailerHelper
  
  # The name of the application, configured in settings.yml
  APPLICATION_NAME = SETTINGS['application_name']
  
  layout 'shared/mailer'
  
  default :from => SETTINGS['admin']['email']
  
  # Mail sent to confirm a new user account
  def account_confirmation(user, host = nil, port = nil)
    host_and_port!(host, port)
    @user = user
    @mail_content = I18n.t('mailer.account_confirmation.message', :name => @user.full_name, :desy => APPLICATION_NAME).html_safe
    mail to: @user.email, subject: t('mailer.account_confirmation.subject', :desy => APPLICATION_NAME)
  end
  
  # Mail containing the link of a lesson
  def see_my_lesson(emails, sender, lesson, message, host = nil, port = nil)
    host_and_port!(host, port)
    @sender = sender
    @message = message
    @lesson_link = sender.id == lesson.user_id ? lesson_viewer_url(*host_and_port(lesson.id, token: lesson.token)) : lesson_viewer_url(*host_and_port(lesson.id))
    @mail_content = I18n.t('mailer.see_my_lesson.message', :name => @sender.full_name, :message => @message, :desy => APPLICATION_NAME).html_safe
    mail to: emails, subject: t('mailer.see_my_lesson.subject', :desy => APPLICATION_NAME)
  end
  
  # Mail to reset password
  def new_password(user, host = nil, port = nil)
    host_and_port!(host, port)
    @user = user
    @mail_content = I18n.t('mailer.reset_password.message', :name => @user.full_name, :desy => APPLICATION_NAME).html_safe
    mail to: @user.email, subject: t('mailer.reset_password.subject', :desy => APPLICATION_NAME)
  end
  
  # Mail to reset password, part 2
  def new_password_confirmed(user, password, host = nil, port = nil)
    host_and_port!(host, port)
    @user, @password = user, password
    @mail_content = I18n.t('mailer.reset_password_confirmed.message', :password => @password, :name => @user.full_name, :desy => APPLICATION_NAME).html_safe
    mail to: @user.email, subject: t('mailer.reset_password_confirmed.subject', :desy => APPLICATION_NAME)
  end
  
  # Mail containing the link of a lesson
  def purchase_resume(emails, purchase, message, host = nil, port = nil)
    host_and_port!(host, port)
    @message = message
    @purchase = purchase
    @mail_content = I18n.t(
      'mailer.purchase_resume.message',
      :release_date    => TimeConvert.to_string(@purchase.release_date),
      :message         => @message,
      :desy            => APPLICATION_NAME,
      :name            => @purchase.name,
      :responsible     => @purchase.responsible,
      :address         => @purchase.address_to_s,
      :phone_number    => @purchase.phone_number,
      :fax             => @purchase.fax,
      :email           => @purchase.email,
      :ssn_code        => @purchase.ssn_code,
      :vat_code        => @purchase.vat_code,
      :accounts_number => @purchase.accounts_number,
      :location        => @purchase.location_to_s,
      :start_date      => TimeConvert.to_string(@purchase.start_date),
      :expiration_date => TimeConvert.to_string(@purchase.expiration_date),
      :token           => @purchase.token,
      :link_sign_up    => sign_up_url(*host_and_port(login: true)),
      :link_home       => home_url(*host_and_port(login: true))
    ).html_safe
    mail to: emails, subject: t('mailer.purchase_resume.subject', :desy => APPLICATION_NAME)
  end
  
  private
  
  # Extracts host and port
  def host_and_port!(host, port)
    @host, @port = host, port
  end
  
end
