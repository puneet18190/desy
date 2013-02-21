class AdminSearchForm < Form

  attr_accessor :search_type, :id, :keyword, :user_id, :subject_id, :element_type, :date_range_field, :date_from, :date_to,:province_id, :town_id, :school_id
  
  validates_numericality_of :id, :user_id, :subject_id, :province_id, :town_id, :school_id
  
  def self.search(search)
    @asf = AdminSearchForm.new(search)
    if @asf.valid? && search[:search_type].present?
      case search[:search_type]
        when 'lessons'
          self.search_lessons(search)
        when 'elements'
          self.search_elements(search)
        when 'users'
          self.search_users(search)
        else
          return false
      end
    else
      return false
    end
  end
  
  def self.search_lessons(search)
    
  end
  
  
end