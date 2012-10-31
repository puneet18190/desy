module ApplicationHelper
  
  def controller_html_class
    "#{h controller_path}-controller"
  end
  
  def action_html_class
    "#{h action_name}-action"
  end
  
  def add_page_parameter(page, an_url)
    x = an_url.split('?')
    return "#{an_url}?page=#{page}".html_safe if x.length == 1
    x = x[1].split('&')
    flag = false
    old_page = 0
    x.each do |xx|
      yy = xx.split('=')
      if yy[0] == 'page'
        flag = true
        old_page = yy[1]
      end
    end
    return flag ? an_url.gsub("page=#{old_page}", "page=#{page}").html_safe : "#{an_url}&page=#{page}".html_safe
  end
  
  def remove_param_from_url(url, param)
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
    return new_url
  end
  
end
