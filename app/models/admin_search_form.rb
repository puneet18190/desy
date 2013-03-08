class AdminSearchForm < Form

  attr_accessor :search_type, :ordering, :id, :title, :keyword, :user, :subject_id, :sti_type, :element_type, :date_range_field, :from, :to,:province_id, :town_id, :school_id, :school_level_id
  
  validates_numericality_of :id, :unless => Proc.new {|c| c.id.blank?}
  validates_presence_of :ordering
  
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
  
  #LESSONS
  def self.search_lessons(params)
    #ADD JOIN FOR LIKES ORDERING
    ### Lesson.joins(:likes).count(group: 'lesson_id', order: 'count_all ASC')
    #ADD JOIN FOR USER NAME ORDERING
    #ADD JOIN FOR SUBJECT NAME ORDERING
    #ADD SELF JOIN FOR LOCATION AND ORDERING
    ### check split('/').include in ancestry field
    lessons = Lesson.order(params[:ordering])
    lessons = lessons.where(id: params[:id]) if params[:id].present?
    lessons = lessons.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    lessons = lessons.where(subject_id: params[:subject_id]) if params[:subject_id].present?
    lessons = lessons.where('users.name ILIKE ? OR users.surname ILIKE ?', "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
    
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      lessons = lessons.where("#{params[:date_range_field]}" => date_range)
    end
    
    if params[:school_id] || params[:user] || params[:province_id] || params[:town_id]
      lessons = lessons.joins(:user)
    end
    
    if params[:school_id].present?
      lessons = lessons.where('users.location_id' => params[:school_id])
    elsif params[:town_id].present?
      town = Location.find(params[:town_id])
      lessons = lessons.where('users.location_id' => town.descendant_ids)
    elsif params[:province_id].present?
      province = Location.find(params[:province_id])
      lessons = lessons.where('users.location_id' => province.descendant_ids)
    end
    
    lessons
  end
  
  #ELEMENTS
  def self.search_elements(params)
    elements = MediaElement.where(converted: true).order(params[:ordering])
    elements = elements.where(id: params[:id]) if params[:id].present?
    elements = elements.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    elements = elements.where(sti_type: params[:sti_type]) if params[:sti_type].present?
    elements = elements.where('users.name ILIKE ? OR users.surname ILIKE ?', "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
    
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      elements = elements.where("#{params[:date_range_field]}" => date_range)
    end
    
    if params[:school_id] || params[:user] || params[:province_id] || params[:town_id]
      elements = elements.joins(:user)
    
      if params[:school_id].present?
        elements = elements.where('users.location_id' => params[:school_id])
      elsif params[:town_id].present?
        town = Location.find(params[:town_id])
        elements = elements.where('users.location_id' => town.descendant_ids)
      elsif params[:province_id].present?
        province = Location.find(params[:province_id])
        elements = elements.where('users.location_id' => province.descendant_ids)
      end
      
    end
    
    elements
  end
  
  #USERS
  def self.search_users(params)
    users = User.order(params[:ordering])
    users = users.where(id: params[:id]) if params[:id].present?
    users = users.where('name ILIKE ? OR surname ILIKE ? OR email ILIKE ?', "%#{params[:user]}%" , "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
    users = users.where('school_level_id' => params[:school_level_id]) if params[:school_level_id].present?
    
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      users = users.where("#{params[:date_range_field]}" => date_range)
    end
    
    if params[:subject_id].present?
      users = users.joins(:subjects).where('users_subjects.subject_id' => params[:subject_id])
    end
    
    if params[:school_id].present?
      users = users.where('location_id' => params[:school_id])
    elsif params[:town_id].present?
      town = Location.find(params[:town_id])
      users = users.where('location_id' => town.descendant_ids)
    elsif params[:province_id].present?
      province = Location.find(params[:province_id])
      users = users.where('location_id' => province.descendant_ids)
    end
    
    users
  end
    
end
