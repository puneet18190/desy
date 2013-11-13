# Global helpers
module ApplicationHelper
  
  def prelogin_contact_us_menu_link
    link_to t('prelogin.contact_us.menu_link'), "mailto:#{SETTINGS['application']['contact_us_email']}"
  end
  
  # Gets the color of description popup into the document gallery
  def documents_type_color(document)
    case document.type
      when :ppt     then '#EA943B'
      when :doc     then '#5DA3DA'
      when :zip     then '#57585B'
      when :exc     then '#92BD4B'
      when :pdf     then '#C61734'
      when :unknown then '#A7A9AC'
    end
  end
  
  # Select for a list of subjects.
  def select_your_subjects(subjects)
    "<option value=\"\">#{t('forms.placeholders.subject_id')}</option>#{options_from_collection_for_select(subjects, 'id', 'description')}".html_safe
  end
  
  # Standard form error message, it attaches the image to the message and includes it in an error frame. Used after ApplicationController#convert_item_error_messages and similar methods.
  def standard_form_error_messages(errors, color = 'white')
    msg = "<img src='/assets/puntoesclamativo.png' style='margin: 0 5px -3px 0' /><span class=\"lower\" style=\"color:#{h color}\">"
    msg << errors.map{ |e| h e }.join('; ')
    return "#{msg}</span>".html_safe
  end
  
  # Extracts the time from seconds
  def seconds_to_time(seconds)
    Time.at(seconds).utc.strftime(seconds >= 3600 ? '%T' : '%M:%S')
  end
  
  # Gets the html class to scope css (controller)
  def controller_html_class
    "#{h controller_path}-controller"
  end
  
  # Gets the html class to scope css (action)
  def action_html_class
    "#{h action_name}-action"
  end
  
  # Manipulates the url, adding or removing parameters
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
    url = URI.escape(url)
    escape ? CGI.escape(url) : url
  end
  
  # Used to give an orientation on images
  def is_horizontal?(width, height, kind)
    ( width.to_f / height.to_f ) >=
      case kind
      when 'cover'                                      then 1.6
      when 'image1'                                     then 1
      when 'image2'                                     then 0.75
      when 'image3', 'image4'                           then 1.55
      when 'video_component', 'video_component_preview' then 1.77
      end
  end
  
  # Resizes the width of an image
  def resize_width(width, height, kind)
    (width.to_f *
      case kind
      when 'cover'                   then 560
      when 'image1'                  then 420
      when 'image2', 'image3'        then 550
      when 'image4'                  then 265
      when 'video_component'         then 88
      when 'video_component_preview' then 360
      end / height).to_i + 1
  end
  
  # Removes the title of a notification. Used in NotificationsController.
  def remove_title_from_notification(notification)
     x = (notification =~ /<\/div>/)
     x.nil? ? notification : notification[x + 6, notification.length]
  end
  
  # Resizes the height of an image
  def resize_height(width, height, kind)
    (height.to_f *
      case kind
      when 'cover'                      then 900
      when 'image1', 'image2', 'image4' then 420
      when 'image3'                     then 860
      when 'video_component'            then 156
      when 'video_component_preview'    then 640
      end / width).to_i + 1
  end
  
  # Method to help debugging views
  if Rails.env.production?
    def jsd(object)
    end
  else
    def jsd(object)
      javascript_tag "console.log(#{object.inspect.to_json})"
    end
  end
  
  # Renders a two digits number even in the case the number is only one-digit
  def two_digits_number(x)
    x < 10 ? "0#{x}" : x.to_s
  end
  
  private
  
  # Submethod of #manipulate_url, that takes into consideration nested url parameters
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
  
  # method to create the title of the html tab
  def title_tag(slides = nil)
    controller = controller_path
    desy = SETTINGS['application_name']
    return t('captions.titles.admin', :desy => desy) if controller.start_with? 'admin/'
    case controller
    when 'documents'
      t('captions.titles.documents', :desy => desy)
    when 'lessons', 'lesson_editor'
      t('captions.titles.lessons', :desy => desy)
    when 'audio_editor', 'image_editor', 'video_editor', 'media_elements'
      t('captions.titles.media_elements', :desy => desy)
    when 'users'
      t('captions.titles.profile', :desy => desy)
    when 'virtual_classroom'
      t('captions.titles.virtual_classroom', :desy => desy)
    when 'lesson_viewer', 'lesson_export'
      if ['index', 'archive'].include?(action_name)
        t('captions.titles.single_lesson', :desy => desy, :lesson => slides.first.lesson.title)
      else
        t('captions.titles.virtual_classroom', :desy => desy)
      end
    else
      t('captions.titles.default', :desy => desy)
    end
  end
  
  # +path+ must be an absolute path
  def full_url(path)
    uri = URI.parse path
    scheme, host, port = request.scheme, request.host, request.port
    port = nil if port == 80
    uri.scheme, uri.host, uri.port = scheme, host, port
    uri.to_s
  end
  
  def url_by_url_type(url, url_type)
    UrlByUrlType.url_by_url_type url ,url_type
  end
  
end
