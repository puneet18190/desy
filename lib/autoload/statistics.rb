module Statistics
  
  class << self
    
    attr_accessor :user
    
    def my_created_lessons
      Lesson.where(user_id: user.id, copied_not_modified: false).count
    end
    
    def my_created_elements
      MediaElement.where(:user_id => user.id).count
    end
    
  end
  
end