class UserMailer < ActionMailer::Base
  
  default :from => CONFIG['admin_email']
  
  def see_my_lesson(emails, sender, lesson, message)
    @sender = sender
    @message = message
    @lesson_link = "#{lesson_viewer_path(lesson.id)}?token=#{lesson.token}"
    mail(:to => emails, :subject => "Welcome to My Awesome Site")
  end
  
end
