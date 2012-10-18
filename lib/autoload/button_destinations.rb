module ButtonDestinations
  
  EXPANDED_LESSON = 'expanded_lesson'
  COMPACT_LESSON = 'compact_lesson'
  EXPANDED_MEDIA_ELEMENT = 'expanded_media_element'
  COMPACT_MEDIA_ELEMENT = 'compact_media_element'
  FOUND_LESSON = 'found_lesson'
  FOUND_MEDIA_ELEMENT = 'found_media_element'
  
  LESSONS = [EXPANDED_LESSON, COMPACT_LESSON, FOUND_LESSON]
  MEDIA_ELEMENTS = [EXPANDED_MEDIA_ELEMENT, COMPACT_MEDIA_ELEMENT, FOUND_MEDIA_ELEMENT]
  
  def self.get(destination, action)
    resp = {}
    if LESSONS.include?(destination)
      resp[:item] = 'lesson'
    elsif MEDIA_ELEMENTS.include?(destination)
      resp[:item] = 'media_element'
    else
      return {}
    end
    if destination.split('_').first == 'expanded'
      resp[:path] = "#{resp[:item]}s/reload_expanded.js.erb"
    else
      resp[:path] = "#{resp[:item]}s/reload_compact.js.erb"
    end
    resp
  end
  
end
