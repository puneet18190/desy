# Module used to extract the object associated to a standard association
module Valid
  
  # Class used to encapsulate the methods of Valid
  class Validness
    
    # Main method of the class. It extracts from +object+ the record corresponding to +column+, using +class+ as associated class. If the field is not valid, or the associated object is not present, it returns nil. If the column is +id+, it returns nil if +object+ is new record and the object itself otherwise.
    def get(object, column, my_class)
      column = column.to_s
      if column == 'id'
        return object.new_record? ? nil : object.class.where(:id => object.id).first
      else
        my_class = get_class_from_column_name column if my_class.nil?
        original_column = object.read_attribute_before_type_cast(column)
        return (original_column.class == String && (original_column =~ /\A\d+\Z/) == 0 || original_column.kind_of?(Integer)) ? my_class.where(:id => original_column).first : nil
      end
    end
    
    private
    
    # Submethod of Validness#get
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
  
  # Method that validates the format of an e-mail address (used in User and MailingListAddress)
  def self.email?(email)
    flag = false
    flag = true if !(/ / =~ email).nil?
    x = email.split('@')
    if x.length == 2
      flag = true if x[0].blank?
      x = x[1].split('.')
      if x.length > 1
        x.each do |comp|
          flag = true if comp.blank?
        end
        flag = true if x.last.length < 2
      else
        flag = true
      end
    else
      flag = true
    end
    !flag
  end
  
  # Method that uses Validness to validate and extract the object associated to a field
  def self.get_association(object, column, my_class=nil)
    x = Validness.new
    x.get object, column, my_class
  end
  
end
