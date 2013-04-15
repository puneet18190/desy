module ApplicationHelper
  
  def select_your_subjects(subjects)
    "<option value=\"\">#{t('forms.placeholders.subject_id')}</option>#{options_from_collection_for_select(subjects, 'id', 'description')}".html_safe
  end
  
  def standard_form_error_messages(errors, color = 'white')
    msg = "<img src='/assets/puntoesclamativo.png' style='margin: 0 5px -3px 0' /><span class=\"lower\" style=\"color:#{h color}\">"
    msg << errors.map{ |e| h e }.join('; ')
    return "#{msg}</span>".html_safe
  end
  
  def seconds_to_time(seconds)
    Time.at(seconds).utc.strftime(seconds >= 3600 ? '%T' : '%M:%S')
  end
  
  def controller_html_class
    "#{h controller_path}-controller"
  end
  
  def action_html_class
    "#{h action_name}-action"
  end

  def manipulate_url(options = {})
    param_to_remove = options[:remove_query_param]
    page            = options[:page]
    escape          = options[:escape]
    path            = options[:path] || request.path

    query_params = request.query_parameters.deep_dup

    query_params.delete(param_to_remove.to_s) if param_to_remove && query_params.present?

    query_params[:page] = page if page

    query_string = get_recursive_array_from_params(query_params).join('&')

    return path if query_string.blank?

    url = "#{path}?#{query_string}"
    
    escape ? CGI.escape(url) : url
  end
  
  def is_horizontal?(width, height, kind)
    # width.to_f / height.to_f : ratio
    ( width.to_f / height.to_f ) >
      case kind
      when 'cover'                                      then 1.6
      when 'image1'                                     then 1
      when 'image2'                                     then 0.75
      when 'image3', 'image4'                           then 1.55
      when 'video_component', 'video_component_preview' then 1.77
      end
  end
  
  def resize_width(width, height, kind)
    width *
      case kind
      when 'cover'                   then 560
      when 'image1'                  then 420
      when 'image2', 'image3'        then 550
      when 'image4'                  then 265
      when 'video_component'         then 88
      when 'video_component_preview' then 360
      end / height
  end
  
  def remove_title_from_notification(notification)
     x = (notification =~ /<\/div>/)
     x.nil? ? notification : notification[x + 6, notification.length]
  end
  
  def resize_height(width, height, kind)
    height *
      case kind
      when 'cover'                      then 900
      when 'image1', 'image2', 'image4' then 420
      when 'image3'                     then 860
      when 'video_component'            then 156
      when 'video_component_preview'    then 640
      end / width
  end
  
  # Metodo per aiutare il debug nelle viste
  if Rails.env.production?
    def jsd(object)
    end
  else
    def jsd(object)
      javascript_tag "console.log(#{object.inspect.to_json})"
    end
  end
  
  private
  
  def get_recursive_array_from_params(params)
    return params if !params.kind_of?(Hash)
    resp = []
    params.each do |k, v|
      rec_ar = get_recursive_array_from_params(v)
      if !rec_ar.kind_of?(Array)
        resp << "#{k}=#{rec_ar}"
      else
        rec_ar.each do |r|
          if (r =~ /\]/).nil?
            resp << "#{k}[#{r.gsub('=', ']=')}"
          else
            temp_string = r[(r =~ /\[/) + 1, r.length]
            resp << "#{k}[#{r[0, (r =~ /\[/)]}][#{temp_string}"
          end
        end
      end
    end
    resp
  end
  
end
