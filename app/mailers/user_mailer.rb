class UserMailer < ActionMailer::Base

  include MailerHelper
  helper MailerHelper
  
  APPLICATION_NAME = SETTINGS['application_name']
  
  layout "user_mailer"

  default :from => SETTINGS['admin']['email']

  def account_confirmation(user, host = nil, port = nil)
    host_and_port!(host, port)
    @user = user
    mail to: @user.email, subject: t('mailer.account_confirmation.subject', :desy => APPLICATION_NAME)
  end
  
  def see_my_lesson(emails, sender, lesson, message, host = nil, port = nil)
    host_and_port!(host, port)
    @sender = sender
    @message = message.blank? ? I18n.t('virtual_classroom.send_link.empty_message') : message[0, I18n.t('language_parameters.notification.message_length_for_send_lesson_link')]
    @lesson_link = lesson_viewer_url(*host_and_port(lesson.id, token: lesson.token))
    mail to: emails, subject: t('mailer.see_my_lesson.subject', :desy => APPLICATION_NAME)
  end

  def new_password(user, password, host = nil, port = nil)
    host_and_port!(host, port)
    @user, @password = user, password
    mail to: @user.email, subject: t('mailer.reset_password.subject', :desy => APPLICATION_NAME)
  end

  private
  def host_and_port!(host, port)
    @host, @port = host, port
  end
  
end
