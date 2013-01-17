module Statistics
  
  class << self
    
    attr_accessor :user
    
    def my_created_lessons
      Lesson.where(user_id: user.id, copied_not_modified: false).count
    end
    
    def my_created_elements
      MediaElement.where(:user_id => user.id).count
    end
    
    def my_liked_lessons(last_n)
      Lesson.where(user_id: user.id, copied_not_modified: false).joins(:likes).group('lessons.id').order('count(likes) DESC').limit(last_n)
    end
    
    def my_likes_count
      Lesson.where(user_id: user.id, copied_not_modified: false).joins(:likes).count
    end
    
    def all_liked_lessons(last_n)
      Lesson.joins(:likes).group('lessons.id').order('count(likes) DESC').limit(last_n)
    end
    
  end
  
end