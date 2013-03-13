class AdminSearchForm < Form
  
  ORDERINGS = {
    :media_elements => [
      'media_elements.id %{ord}',
      'media_elements.title %{ord}',
      'media_elements.sti_type %{ord}',
      'users.surname %{ord}, users.name %{ord}',
      'media_elements.created_at %{ord}',
      'media_elements.updated_at %{ord}',
      'media_elements.is_public %{ord}'
    ],
    :lessons => [
      'lessons.id %{ord}',
      'lessons.title %{ord}',
      'subjects.description %{ord}',
      'users.surname %{ord}, users.name %{ord}',
      'lessons.created_at %{ord}',
      'lessons.updated_at %{ord}'
    ],
    :users => []
  }
  
  def self.search_lessons(params)
    resp = Lesson.select('lessons.id AS id, title, subject_id, user_id, lessons.created_at AS created_at, lessons.updated_at AS updated_at, (SELECT COUNT (*) FROM likes WHERE likes.lesson_id = lessons.id) AS likes_count')
    if params[:ordering].present?
      ord = ORDERINGS[:lessons][params[:ordering].to_i]
      if ord.nil? && params[:ordering].to_i == 6
        desc = params[:desc] == 'true' ? 'DESC' : 'ASC'
        resp = resp.order("likes_count #{desc}")
      else
        if params[:ordering].to_i == 2
          resp = resp.joins(:subject)
        else
          ord = ORDERINGS[:lessons][0] if ord.nil?
        end
        if params[:desc] == 'true'
          ord = ord.gsub('%{ord}', 'DESC')
        else
          ord = ord.gsub('%{ord}', 'ASC')
        end
        resp = resp.order(ord)
      end
    end
    resp = resp.where(:lessons => {:id => params[:id]}) if params[:id].present?
    resp = resp.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
    resp = resp.where(:subject_id => params[:subject_id]) if params[:subject_id].present?
    if params[:date_range_field].present? && params[:from].present? && params[:to].present?
      date_range = (Date.strptime(params[:from], '%d-%m-%Y').beginning_of_day)..(Date.strptime(params[:to], '%d-%m-%Y').end_of_day)
      resp = resp.where(:lessons => {:"#{params[:date_range_field]}" => date_range})
    end
    with_joins = params[:user].present?
    SETTINGS['location_types'].map{|type| type.downcase}.each do |type|
      with_joins = true if params[type].present? && params[type] != '0'
    end
    if with_joins
      resp = resp.joins(:user)
      resp = resp.where('users.name ILIKE ? OR users.surname ILIKE ?', "%#{params[:user]}%", "%#{params[:user]}%") if params[:user].present?
      location = Location.get_from_chain_params(params)
      if location
        if location.depth == SETTINGS['location_types'].length - 1
          resp = resp.where(:users => {:location_id => location.id})
        else
          resp = resp.joins(:user => :location)
          anc = location.ancestry_with_me
          anc.chop! if location.depth == SETTINGS['location_types'].length - 2
          resp = resp.where('ancestry LIKE ?', "#{anc}%")
        end
      end
    end
    resp
  end
  
  def self.search_media_elements(params)
    resp = MediaElement.where(:converted => true)
    if params[:ordering].present?
      ord = ORDERINGS[:media_elements][params[:ordering].to_i]
      ord = ORDERINGS[:media_elements][0] if ord.nil?
      if params[:desc] == 'true'
        ord = ord.gsub('%{ord}', 'DESC')
      else
        ord = ord.gsub('%{ord}', 'ASC')
      end
      resp = resp.order(ord)
    end
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
      location = Location.get_from_chain_params(params)
      if location
        if location.depth == SETTINGS['location_types'].length - 1
          resp = resp.where(:users => {:location_id => location.id})
        else
          resp = resp.joins(:user => :location)
          anc = location.ancestry_with_me
          anc.chop! if location.depth == SETTINGS['location_types'].length - 2
          resp = resp.where('ancestry LIKE ?', "#{anc}%")
        end
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
  
end
