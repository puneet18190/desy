module ApplicationHelper
  
  def media_elements_error_messages(errors)
    msg = ""
    errors.each do |key,val|
      msg << "#{key.to_s}: #{val[0].to_s}, " 
    end
    return msg[0..-3].html_safe
  end
  
  def seconds_to_time(secs)
    mm = secs / 60
    ss = secs % 60
    hh = mm / 60
    mm = mm % 60
    resp = ''
    resp = "#{hh}:" if hh > 0
    resp = "#{resp}#{mm}:" if mm > 9
    resp = "#{resp}0#{mm}:" if mm < 10
    resp = "#{resp}#{ss}" if ss > 9
    resp = "#{resp}0#{ss}" if ss < 10
    resp
  end
  
  def controller_html_class
    "#{h controller_path}-controller"
  end
  
  def action_html_class
    "#{h action_name}-action"
  end
  
  def add_page_parameter(page, an_url)
    an_url = an_url.html_safe
    x = an_url.split('?')
    return "#{an_url}?page=#{page}".html_safe if x.length == 1
    x = x[1].split('&')
    flag = false
    old_page = 0
    cont = 1
    pivot = '&'
    x.each do |xx|
      yy = xx.split('=')
      if yy[0] == 'page'
        flag = true
        old_page = yy[1]
        pivot = '?' if cont == 1
      end
      cont += 1
    end
    return flag ? an_url.gsub("#{pivot}page=#{old_page}", "#{pivot}page=#{page}").html_safe : "#{an_url}&page=#{page}".html_safe
  end
  
  def remove_param_from_url(url, param)
    url = url.html_safe
    return url if (url =~ /#{param}/).nil?
    x = url.split("#{param}=")
    pivot = "#{param}="
    if x[0].last == '&'
      pivot = "&#{pivot}"
    end
    if (x[1] =~ /&/).nil?
      new_url = url.gsub("#{pivot}#{x[1]}", '')
    else
      new_url = url.gsub("#{pivot}#{x[1].split('&')[0]}", '')
    end
    new_url.chop! if new_url.last == '?'
    new_url.gsub!('?&', '?') if !(new_url =~ /\?&/).nil?
    return new_url.html_safe
  end
  
  def is_horizontal?(width, height, kind)
    ratio = width.to_f / height.to_f
    result = case kind
      when 'cover'
        ratio > 1.6
      when 'image1'
        ratio > 1
      when 'image2'
        ratio > 0.75
      when 'image3'
        ratio > 1.55
      when 'image4'
        ratio > 1.55
      when 'video_component'
        ratio > 1.77
      when 'video_component_preview'
        ratio > 1.77
    end
  end
  
  def resize_width(width, height, kind)
    result = case kind
      when 'cover'
        (width * 560) / height
      when 'image1'
        (width * 420) / height
      when 'image2'
        (width * 550) / height
      when 'image3'
        (width * 550) / height
      when 'image4'
        (width * 265) / height
      when 'video_component'
        (width * 88) / height
      when 'video_component_preview'
        (width * 360) / height
    end
  end
  
  def resize_height(width, height, kind)
    result = case kind
      when 'cover'
        (height * 900) / width
      when 'image1'
        (height * 420) / width
      when 'image2'
        (height * 420) / width
      when 'image3'
        (height * 860) / width
      when 'image4'
        (height * 420) / width
      when 'video_component'
        (height * 156) / width
      when 'video_component_preview'
        (height * 640) / width
    end
  end
  
  # Metodo per aiutare il debug nelle viste
  def js_log(object)
    javascript_tag "console.log(#{object.inspect.to_json})"
  end
  alias jsl js_log
  
end
