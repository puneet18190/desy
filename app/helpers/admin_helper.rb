module AdminHelper
  
  def page_items_counter(items)
    if items.length > 0
      from = 1
      if items.count > 25
        to = 25
      else
        to = items.count
      end
      if params[:page]
        from = (25 * (params[:page].to_i - 1)) + 1
        if(params[:page].to_i < items.num_pages.to_i)
          to = to * params[:page].to_i
        else
          to = items.total_count
        end
      end
      label = "admin.#{items.first.class.name.pluralize.downcase}.name"
      label = 'admin.media_elements.name' if MediaElement::STI_TYPES.include?(items.first.class.name)
      return "#{from} - #{to} #{t('admin.general.of_range')} #{items.total_count} #{t(label)}".downcase
    end
  end
  
end
