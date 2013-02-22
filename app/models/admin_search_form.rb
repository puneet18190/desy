class AdminSearchForm < Form

  attr_accessor :search_type, :id, :title, :keyword, :user, :subject_id, :element_type, :date_range_field, :from, :to,:province_id, :town_id, :school_id
  
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
    lessons = lessons.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    lessons = lessons.where(subject_id: params[:subject_id]) if params[:subject_id].present?
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      lessons = lessons.where("#{params[:date_range_field]}" => date_range)
    end
    if params[:school_id] || params[:user]
      lessons = lessons.joins(:user)
    end
    lessons = lessons.where('users.location_id' => params[:school_id]) if params[:school_id].present?
    lessons = lessons.where('users.name ILIKE ? OR users.surname ILIKE ?', "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
    lessons
  end
    
end