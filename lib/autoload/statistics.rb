module Statistics
  
  class << self
    
    attr_accessor :user
    
    def my_created_lessons
      Lesson.where(user_id: user.id, copied_not_modified: false).count
    end
    
    def my_created_elements
      MediaElement.where(:user_id => user.id).count
    end
    
    def my_copied_lessons
      copied_id = Lesson.where('parent_id IS NOT NULL').pluck(:id)
      return Lesson.where("user_id != ? AND id IN(?)", user.id, copied_id).count
    end
    
    def my_liked_lessons(first_n)
      Lesson.where(user_id: user.id, copied_not_modified: false).joins(:likes).group('lessons.id').order('count(likes) DESC').limit(first_n)
    end
    
    def my_likes_count
      Lesson.where(user_id: user.id, copied_not_modified: false).joins(:likes).count
    end
    
    def all_liked_lessons(first_n)
      Lesson.joins(:likes).group('lessons.id').order('count(likes) DESC').limit(first_n)
    end
    
    def all_users
      User.count
    end
    
    def all_users_like
      User.joins(:lessons => :likes).group('users.id').order('count(likes) DESC').count()
    end
    
    def all_shared_lessons
      Lesson.where(is_public: true).count
    end
    
    def all_shared_elements
      MediaElement.where(is_public: true).count
    end
    
    def all_liked_users(first_n)
      Lesson.where(user_id: user.id).joins(:likes).group('lessons.id').order('count(likes) DESC').limit(first_n)
    end
    
    def all_subjects_chart
      amt = ""
      desc = ""
      Subject.all.each do |sbj|
        amt = amt + sbj_to_percentage(sbj.lessons.count).to_s + ","
        desc = desc + sbj.description.to_s + ","
      end
      return [amt.to_s[0..-2], desc.to_s[0..-2]]
    end
    
    private
    
    def sbj_to_percentage(val)
      tot = Lesson.count
      if(val > 0)
        res = (val.to_f * 100) / tot.to_f
        res.round(2)
      else
        return 0
      end
    end
    
  end
  
end