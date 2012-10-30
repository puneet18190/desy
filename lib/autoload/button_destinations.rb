module ButtonDestinations
  
  EXPANDED_LESSON = 'expanded_lesson'
  COMPACT_LESSON = 'compact_lesson'
  EXPANDED_MEDIA_ELEMENT = 'expanded_media_element'
  COMPACT_MEDIA_ELEMENT = 'compact_media_element'
  FOUND_LESSON = 'found_lesson'
  FOUND_MEDIA_ELEMENT = 'found_media_element'
  
  LESSONS = [EXPANDED_LESSON, COMPACT_LESSON, FOUND_LESSON]
  MEDIA_ELEMENTS = [EXPANDED_MEDIA_ELEMENT, COMPACT_MEDIA_ELEMENT, FOUND_MEDIA_ELEMENT]
  
  def self.get(destination, action, container, html_params, item_id)
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
        resp[:path] = 'lessons/reload_compact.js' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'unpublish'
        resp[:path] = 'lessons/reload_compact.js' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'like'
        if destination.split('_').first == 'expanded'
          resp[:path] = 'lessons/reload_expanded.js' if resp[:item] == 'lesson'
        else
          resp[:path] = 'lessons/reload_compact.js' if resp[:item] == 'lesson'
        end
      when 'dislike'
        if destination.split('_').first == 'expanded'
          resp[:path] = 'lessons/reload_expanded.js' if resp[:item] == 'lesson'
        else
          resp[:path] = 'lessons/reload_compact.js' if resp[:item] == 'lesson'
        end
      when 'add_lesson'
        resp[:path] = 'lessons/reload_compact.js' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'remove_lesson'
        resp[:path] = 'lessons/reload_compact.js' if [COMPACT_LESSON, FOUND_LESSON].include?(destination)
      when 'add'
        case destination
          when EXPANDED_LESSON
            resp[:path] = false
            resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
          when EXPANDED_MEDIA_ELEMENT
            resp[:path] = false
            resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
          when FOUND_LESSON
            resp[:path] = 'lessons/reload_compact.js'
          when FOUND_MEDIA_ELEMENT
            resp[:path] = 'media_elements/reload_compact.js'
        end
      when 'remove'
        case destination
          when COMPACT_LESSON
            resp[:path] = false
            resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
          when COMPACT_MEDIA_ELEMENT
            resp[:path] = false
            resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
          when EXPANDED_MEDIA_ELEMENT
            resp[:path] = false
            resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
          when FOUND_LESSON
            resp[:path] = 'lessons/reload_compact.js'
          when FOUND_MEDIA_ELEMENT
            resp[:path] = 'media_elements/reload_compact.js'
        end
      when 'destroy'
        if [FOUND_LESSON, COMPACT_LESSON].include?(destination)
          resp[:path] = false
          resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
        elsif [FOUND_MEDIA_ELEMENT, COMPACT_MEDIA_ELEMENT].include?(destination)
          resp[:path] = false
          resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
        elsif destination == EXPANDED_MEDIA_ELEMENT
          resp[:path] = false
          resp[:reload_url] = ButtonDestinations.construct_reload_url destination, container, html_params, item_id
        end
      when 'copy'
        resp[:path] = 'lessons/insert.js' if resp[:item] == 'lesson'
    end
    resp = {} if !resp.has_key?(:path)
    resp[:reload_url] = '' if !resp.has_key?(:reload_url)
    resp
  end
  
  def self.construct_reload_url(destination, container, html_params, item_id)
    params = "?js_reload=true&delete_item=#{destination}_#{item_id}"
    x = html_params.split('-')
    params = "#{params}&page=#{x[0]}" if x[0] != 'N'
    params = "#{params}&for_page=#{x[1]}" if x[1] != 'N'
    params = "#{params}&filter=#{x[2]}" if x[2] != 'N'
    params = "#{params}&format=#{x[3]}" if x[3] != 'N'
    return "/#{container}#{params}"
  end
  
end
