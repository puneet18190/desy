module SearchOrders
  
  UPDATED_AT = 'updated_at'
  LIKES = 'likes'
  TITLE = 'title'
  
  LESSONS_SET = [UPDATED_AT, LIKES, TITLE]
  MEDIA_ELEMENTS_SET = [UPDATED_AT, TITLE]
  
  CAPTIONS = {
    UPDATED_AT => I18n.t('orders.updated_at'),
    LIKES => I18n.t('orders.likes'),
    TITLE => I18n.t('orders.title')
  }
  
end
