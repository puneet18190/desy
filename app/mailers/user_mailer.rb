class UserMailer < ActionMailer::Base
  
  default :from => CONFIG['admin_email']
  
  def see_my_lesson(email, sender, lesson)
    @sender = sender
    @url = Rails.root.join "/lesson_viewer/#{lesson.id}/show?token=#{lesson.token}"
    mail(:to => email, :subject => "Welcome to My Awesome Site")
  end
  
end
