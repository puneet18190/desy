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
    if hh > 0
      resp = "#{hh}:"
      if mm == 0
        resp = "#{resp}00:"
      elsif mm < 10
        resp = "#{resp}0#{mm}:"
      else
        resp = "#{resp}#{mm}:"
      end
      if ss == 0
        resp = "#{resp}00"
      elsif mm < 10
        resp = "#{resp}0#{ss}"
      else
        resp = "#{resp}#{ss}"
      end
    elsif mm > 0
      resp = "#{mm}:"
      if ss == 0
        resp = "#{resp}00"
      elsif ss < 10
        resp = "#{resp}0#{ss}"
      else
        resp = "#{resp}#{ss}"
      end
    else
      resp = ss.to_s
    end
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
  
  # Metodo per aiutare il debug nelle viste
  def js_log(object)
    javascript_tag "console.log(#{object.inspect.to_json})"
  end
  alias jsl js_log
  
end
