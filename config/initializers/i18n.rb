module I18n
  
  class << self
    
    def translate_with_html_escaping(*args)
      if args[-1].is_a?(Hash)
        args[-1] = Hash[ args[-1].map{ |k,v| [k, ([:locale, :throw, :raise].include?(k) ? v : h(v)) ] } ]
      end
      translate_without_html_escaping(*args)
    end
    
    #=> translate -> translate_without_html_escaping
    #=> translate_with_html_escaping -> translate
    alias_method_chain :translate, :html_escaping
    
  end
  
end
