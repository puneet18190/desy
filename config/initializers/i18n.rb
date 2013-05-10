module I18n
  include ERB::Util
  
  class << self
    
    def translate_with_html_escaping(*args)
      if args[-1].is_a?(Hash)
        args[-1] = Hash[ args[-1].map{ |k,v| [k, ([:locale, :throw, :raise, :link, :resolve, :default].include?(k) ? v : ERB::Util.h(v)) ] } ]
      end
      translate_without_html_escaping(*args)
    end
    
    alias_method_chain :translate, :html_escaping
    alias_method :t, :translate_with_html_escaping
    
  end
  
end
