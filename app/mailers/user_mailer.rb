class UserMailer < ActionMailer::Base

  include MailerHelper
  helper MailerHelper
  
  APPLICATION_NAME = SETTINGS['application_name']
  
  layout 'shared/mailer'

  default :from => SETTINGS['admin']['email']

  def account_confirmation(user, host = nil, port = nil)
    host_and_port!(host, port)
    @user = user
    @mail_content = I18n.t('mailer.account_confirmation.message', :name => @user.full_name, :desy => SETTINGS['application_name']).html_safe
    mail to: @user.email, subject: t('mailer.account_confirmation.subject', :desy => APPLICATION_NAME)
  end
  
  def see_my_lesson(emails, sender, lesson, message, host = nil, port = nil)
    host_and_port!(host, port)
    @sender = sender
    @message = message
    @lesson_link = sender.id == lesson.user_id ? lesson_viewer_url(*host_and_port(lesson.id, token: lesson.token)) : lesson_viewer_url(*host_and_port(lesson.id))
    @mail_content = I18n.t('mailer.see_my_lesson.message', :name => @sender.full_name, :message => @message, :desy => SETTINGS['application_name']).html_safe
    mail to: emails, subject: t('mailer.see_my_lesson.subject', :desy => APPLICATION_NAME)
  end

  def new_password(user, password, host = nil, port = nil)
    host_and_port!(host, port)
    @user, @password = user, password
    @mail_content = I18n.t('mailer.reset_password.message', :password => @password, :name => @user.full_name, :desy => SETTINGS['application_name']).html_safe
    mail to: @user.email, subject: t('mailer.reset_password.subject', :desy => APPLICATION_NAME)
  end

  private
  def host_and_port!(host, port)
    @host, @port = host, port
  end
  
end
