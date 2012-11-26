class UserMailer < ActionMailer::Base
  
  default :from => CONFIG['admin_email']
  
  def see_my_lesson(emails, sender, lesson, message)
    @sender = sender
    @message = message
    @url = Rails.root.join "/lesson_viewer/#{lesson.id}/show?token=#{lesson.token}"
    mail(:to => emails, :subject => "Welcome to My Awesome Site")
  end
  
end
