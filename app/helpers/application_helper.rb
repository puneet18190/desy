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
  
  def add_js_parameters(an_url, delete_id)
    x = an_url.split('?')
    return "#{an_url}?js_reload=true&delete_item=#{delete_id}".html_safe if x.length == 1
    x = x[1].split('&')
    flag = false
    old_delete_item = 0
    old_js_reload = ''
    x.each do |xx|
      yy = xx.split('=')
      if yy[0] == 'js_reload'
        flag = true
        old_js_reload = yy[1]
      end
      if yy[0] == 'delete_item'
        flag = true
        old_delete_item = yy[1]
      end
    end
    if flag
      return an_url.gsub("delete_item=#{old_delete_item}", "delete_item=#{delete_idem}").gsub("js_reload=#{old_js_reload}", 'js_reload=true').html_safe
    else
      return "#{an_url}&js_reload=true&delete_item=#{delete_id}".html_safe
    end
  end
  
end
