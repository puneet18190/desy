module SearchOrders
  
  UPDATED_AT = 'updated_at'
  LIKES = 'likes'
  TITLE = 'title'
  PUBLICATION_DATE = 'publication_date'
  
  LESSONS_SET = [UPDATED_AT, LIKES, TITLE]
  MEDIA_ELEMENTS_SET = [UPDATED_AT, PUBLICATION_DATE, TITLE]
  
  CAPTIONS = {
    UPDATED_AT => I18n.t('orders.updated_at'),
    LIKES => I18n.t('orders.likes'),
    TITLE => I18n.t('orders.title'),
    PUBLICATION_DATE => I18n.t('orders.publication_date')
  }
  
end
