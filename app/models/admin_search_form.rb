class AdminSearchForm < Form
  
  def self.search_lessons(params)
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
  
  def self.search_media_elements(params)
    resp = MediaElement.where(:converted => true)
    resp = resp.where(:media_elements => {:id => params[:id]}) if params[:id].present?
    resp = resp.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    resp = resp.where(:sti_type => params[:sti_type]) if params[:sti_type].present?
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      resp = resp.where(:media_elements => {:"#{params[:date_range_field]}" => date_range})
    end
    with_joins = params[:user].present?
    SETTINGS['location_types'].map{|type| type.downcase}.each do |type|
      with_joins = true if params[type].present? && params[type] != '0'
    end
    if with_joins
      resp = resp.joins(:user)
      resp = resp.where('users.name ILIKE ? OR users.surname ILIKE ?', "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
      location = Location.find_by_id get_location_param(params)
      if location
        # fare le cose qui
      end
    end
    resp
  end
  
  def self.search_users(params)
    users = User.order(params[:ordering])
    users = users.where(id: params[:id]) if params[:id].present?
    users = users.where('name ILIKE ? OR surname ILIKE ? OR email ILIKE ?', "%#{params[:user]}%" , "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
    users = users.where('school_level_id' => params[:school_level_id]) if params[:school_level_id].present?
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      users = users.where("#{params[:date_range_field]}" => date_range)
    end
    users = users.where("users.created_at >= ?", params[:recency]) if params[:recency].present?
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
  
  private
  
  def get_location_param(params)
    flag = true
    index = SETTINGS['location_types'].length - 1
    loc_param = params[SETTINGS['location_types'].last.downcase]
    while flag && index >= 0
      if loc_param.present? && loc_param != '0'
        flag = false
      else
        index -= 1
        loc_param = params[SETTINGS['location_types'][index].downcase]
      end
    end
    loc_param
  end
  
end
