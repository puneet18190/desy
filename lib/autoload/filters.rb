module Filters
  
  ALL_LESSONS = 'all_lessons'
  PRIVATE = 'private'
  SHARED = 'shared'
  LINKED = 'linked'
  ONLY_MINE = 'only_mine'
  COPIED = 'copied'
  ALL_MEDIA_ELEMENTS = 'all_media_elements'
  VIDEO = 'video'
  AUDIO = 'audio'
  IMAGE = 'image'
  
  LESSONS_SET = [ALL_LESSONS, PRIVATE, SHARED, LINKED, ONLY_MINE, COPIED]
  MEDIA_ELEMENTS_SET = [ALL_MEDIA_ELEMENTS, VIDEO, AUDIO, IMAGE]
  
  CAPTIONS = {
    ALL_LESSONS => I18n.t('filters.all_lessons'),
    PRIVATE => I18n.t('filters.private'),
    SHARED => I18n.t('filters.shared'),
    LINKED => I18n.t('filters.linked'),
    ONLY_MINE => I18n.t('filters.only_mine'),
    COPIED => I18n.t('filters.copied'),
    ALL_MEDIA_ELEMENTS => I18n.t('filters.all_media_elements'),
    VIDEO => I18n.t('filters.video'),
    AUDIO => I18n.t('filters.audio'),
    IMAGE => I18n.t('filters.image')
  }
  
end
