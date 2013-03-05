module Statistics
  
  class << self
    
    attr_accessor :user
    
    
    # PART 1: statistics retrieving ActiveRecord arrays
    
    # The first n lessons of the current user, ordered by the number of likes received
    def my_liked_lessons(first_n)
      Lesson.select('id, title, (SELECT COUNT (*) FROM likes WHERE likes.lesson_id = lessons.id) AS likes_count').where(:user_id => user.id).order('likes_count DESC, updated_at DESC').limit(first_n)
    end
    
    # The first n lessons liked by users in all DESY
    def all_liked_lessons(first_n)
      Lesson.select('id, title, (SELECT COUNT (*) FROM likes WHERE likes.lesson_id = lessons.id) AS likes_count').order('likes_count DESC, updated_at DESC').limit(first_n)
    end
    
    # The first n users who received more likes
    def all_users_like(first_n)
      Like.joins(:lesson, :lesson => :user).group('users.id').select('users.id, users.name, users.surname, COUNT(*) AS likes_count').order('likes_count DESC, created_at DESC').limit(first_n)
    end
    
    
    # PART 2: statistics retrieving numbers
    
    # Lessons created by the current user, and copied by other users
    def my_copied_lessons
      Lesson.joins('INNER JOIN lessons AS parent_lessons ON (parent_lessons.id = lessons.parent_id)').where('lessons.user_id != ? AND parent_lessons.user_id = ?', user.id, user.id).count
    end
    
    # Lessons created by the current user (not including the lessons he copied and still not modified)
    def my_created_lessons
      Lesson.where(:user_id => user.id, :copied_not_modified => false).count
    end
    
    # Media Elements loaded or created by the current user (including the public ones, that might not be anymore in the user's section)
    def my_created_elements
      MediaElement.where(:user_id => user.id).count
    end
    
    # The total amount of likes received by lessons created by the current user
    def my_likes_count
      Like.joins(:lesson).where(:lessons => {:user_id => user.id}).count
    end
    
    # The number of users in DESY
    def all_users
      User.count
    end
    
    # The number of shared lessons in the application
    def all_shared_lessons
      Lesson.where(:is_public => true).count
    end
    
    # The number of shared media elements in the application
    def all_shared_elements
      MediaElement.where(:is_public => true).count
    end
    
    
    # PART 3: statistics retrieving charts
    
    # Chart representing the distribution of subjects among lessons
    def all_subjects_chart
      amt = ''
      desc = ''
      Subject.all.each do |sbj|
        if sbj.lessons.count > 0
          amt = amt + sbj_to_percentage(sbj.lessons.count).to_s + ','
        end
        desc = desc + sbj.description.to_s + ','
      end
      return [amt.to_s[0..-2], desc.to_s[0..-2]]
    end
    
    private
    
    def sbj_to_percentage(val)
      tot = Lesson.count
      res = (val.to_f * 100) / tot.to_f
      res.round(2)
    end
    
  end
  
end
