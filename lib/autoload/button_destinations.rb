module ButtonDestinations
  
  EXPANDED_LESSON = 'expanded_lesson'
  COMPACT_LESSON = 'compact_lesson'
  EXPANDED_MEDIA_ELEMENT = 'expanded_media_element'
  COMPACT_MEDIA_ELEMENT = 'compact_media_element'
  FOUND_LESSON = 'found_lesson'
  FOUND_MEDIA_ELEMENT = 'found_media_element'
  
  LESSONS = [EXPANDED_LESSON, COMPACT_LESSON, FOUND_LESSON]
  MEDIA_ELEMENTS = [EXPANDED_MEDIA_ELEMENT, COMPACT_MEDIA_ELEMENT, FOUND_MEDIA_ELEMENT]
  
  def self.get(destination, action, container)
    resp = {}
    if LESSONS.include?(destination)
      resp[:item] = 'lesson'
    elsif MEDIA_ELEMENTS.include?(destination)
      resp[:item] = 'media_element'
    else
      return {}
    end
    case action
      when 'publish'
        resp[:path] = 'lessons/reload_compact.js.erb' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'unpublish'
        resp[:path] = 'lessons/reload_compact.js.erb' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'like'
        if destination.split('_').first == 'expanded'
          resp[:path] = 'lessons/reload_expanded.js.erb' if resp[:item] == 'lesson'
        else
          resp[:path] = 'lessons/reload_compact.js.erb' if resp[:item] == 'lesson'
        end
      when 'dislike'
        if destination.split('_').first == 'expanded'
          resp[:path] = 'lessons/reload_expanded.js.erb' if resp[:item] == 'lesson'
        else
          resp[:path] = 'lessons/reload_compact.js.erb' if resp[:item] == 'lesson'
        end
      when 'add_lesson'
        resp[:path] = 'lessons/reload_compact.js.erb' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'remove_lesson'
        resp[:path] = 'lessons/reload_compact.js.erb' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'add'
        case destination
          when EXPANDED_LESSON
            resp[:path] = false
          when EXPANDED_MEDIA_ELEMENT
            resp[:path] = false
          when FOUND_LESSON
            resp[:path] = 'lessons/reload_compact.js.erb'
          when FOUND_MEDIA_ELEMENT
            resp[:path] = 'media_elements/reload_compact.js.erb'
        end
      when 'remove'
        case destination
          when COMPACT_LESSON
            resp[:path] = false
          when COMPACT_MEDIA_ELEMENT
            resp[:path] = false
          when EXPANDED_MEDIA_ELEMENT
            resp[:path] = false
          when FOUND_LESSON
            resp[:path] = 'lessons/reload_compact.js.erb'
          when FOUND_MEDIA_ELEMENT
            resp[:path] = 'media_elements/reload_compact.js.erb'
        end
      when 'destroy'
        if [FOUND_LESSON, COMPACT_LESSON].include?(destination)
          resp[:path] = false
        elsif [FOUND_MEDIA_ELEMENT, COMPACT_MEDIA_ELEMENT].include?(destination)
          resp[:path] = false
        elsif destination == EXPANDED_MEDIA_ELEMENT
          resp[:path] = false
        end
      when 'copy'
        resp[:path] = 'lessons/insert.js.erb' if resp[:item] == 'lesson'
    end
    resp = {} if !resp.has_key?(:path)
    resp
  end
  
end
