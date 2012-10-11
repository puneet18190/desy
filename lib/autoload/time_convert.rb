module TimeConvert
  
  class TimeConverter
    
    def to_string a_time
      return '' if !a_time.kind_of?(Time)
      return 'blalblabl'
    end
    
    private
    
    def get_class_from_column_name x
      resp = ''
      x.split('_').each do |my_split|
        if my_split != 'id'
          resp = "#{resp}#{my_split.capitalize}"
        end
      end
      return resp.constantize
    end
    
  end
  
  def self.to_string a_time
    x = TimeConverter.new
    x.to_string a_time
  end
  
end
