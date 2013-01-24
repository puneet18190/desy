class UserMailer < ActionMailer::Base

  include MailerHelper
  helper MailerHelper

  layout "user_mailer"

  default :from => SETTINGS['admin']['email']

  def account_confirmation(user, host = nil, port = nil)
    host_and_port!(host, port)
    @user = user
    mail to: @user.email, subject: t('emails.account_confirmation.subject')
  end
  
  def see_my_lesson(emails, sender, lesson, message, host = nil, port = nil)
    host_and_port!(host, port)
    @sender = sender
    @message = message
    @lesson_link = lesson_viewer_url(*host_and_port(lesson.id, token: lesson.token))
    mail to: emails, subject: t('emails.see_my_lesson.subject')
  end

  def new_password(user, password, host = nil, port = nil)
    host_and_port!(host, port)
    @user, @password = user, password
    mail to: @user.email, subject: t('emails.new_password.subject')
  end

  private
  def host_and_port!(host, port)
    @host, @port = host, port
  end
  
end
