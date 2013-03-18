module TimeConvert
  
  class TimeConverter
    
    def to_string(a_time)
      return '' if !a_time.kind_of?(Time)
      case I18n.t('time.format')
        when 'english'
          return convert_in_english a_time
        when 'chinese'
          return convert_in_chinese a_time
        when 'italian'
          return convert_in_italian a_time
        else
          return a_time.to_s
      end
    end
    
    private
    
    def convert_in_english(a_time)
      day = a_time.day
      month = a_time.month
      year = a_time.year
      return "#{english_month(month)} #{day}#{english_day_suffix(day)}, #{year}"
    end
    
    def english_day_suffix(x)
      if [1, 21, 31].include? x
        return 'st'
      elsif [2, 22].include? x
        return 'nd'
      elsif [3, 23].include? x
        return 'rd'
      else
        return 'th'
      end
    end
    
    def english_month(x)
      case x
        when 1
          return 'January'
        when 2
          return 'February'
        when 3
          return 'March'
        when 4
          return 'April'
        when 5
          return 'May'
        when 6
          return 'June'
        when 7
          return 'July'
        when 8
          return 'August'
        when 9
          return 'September'
        when 10
          return 'October'
        when 11
          return 'November'
        when 12
          return 'December'
        else
          return ''
      end
    end
    
    def convert_in_chinese(a_time)
      day = a_time.day
      month = a_time.month
      year = a_time.year
      return "#{english_month(month)} #{day}#{english_day_suffix(day)}, #{year}"
    end
    
    def conver_in_italian(a_time)
      a_time.to_s
    end
    
  end
  
  def self.to_string(a_time)
    x = TimeConverter.new
    x.to_string a_time
  end
  
end
