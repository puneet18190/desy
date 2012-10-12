module Valid
  
  class Validness
    
    def get(object, column, my_class)
      column = column.to_s
      if column == 'id'
        return object.new_record? ? nil : object.class.where(:id => object.id).first
      else
        my_class = get_class_from_column_name column if my_class.nil?
        original_column = object.read_attribute_before_type_cast(column)
        return original_column.kind_of?(Integer) ? my_class.where(:id => original_column).first : nil
      end
    end
    
    private
    
    def get_class_from_column_name(x)
      resp = ''
      x.split('_').each do |my_split|
        if my_split != 'id'
          resp = "#{resp}#{my_split.capitalize}"
        end
      end
      return resp.constantize
    end
    
  end
  
  def self.get_association(object, column, my_class=nil)
    x = Validness.new
    x.get object, column, my_class
  end
  
end
