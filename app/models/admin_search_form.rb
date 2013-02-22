class AdminSearchForm < Form

  attr_accessor :search_type, :id, :keyword, :user_id, :subject_id, :element_type, :date_range_field, :from, :to,:province_id, :town_id, :school_id
  
  validates_numericality_of :id, :unless => Proc.new {|c| c.id.blank?}
  
  def self.search(params, search_type)
    if params
      _d params
      asf = new(params)
      if asf.valid?
        case search_type.to_s
        when 'lessons', 'elements', 'users'
          send :"search_#{search_type}", params
        else
          return false
        end
      else
        return false
      end
    end
  end
  
  def self.search_lessons(params)
    lessons = Lesson.order('id DESC')
    lessons = lessons.where(id: params[:id]) if params[:id].present?
    lessons = lessons.where('title ILIKE ?', "%#{params[:keyword]}%") if params[:keyword].present?
    lessons = lessons.where(subject_id: params[:subject_id]) if params[:subject_id].present?
    lessons
  end
    
end