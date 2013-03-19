module LessonsMediaElementsShared
  
  def status(s)
    I18n.t("statuses.#{table_name}.#{s}")
  end
  
  def filter(f)
    I18n.t("statuses.#{table_name}.#{f}")
  end
  
  def search_order(so)
    I18n.t("statuses.#{table_name}.#{so}")
  end
  
end
