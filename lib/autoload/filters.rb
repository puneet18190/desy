module Filters
  
  ALL_LESSONS = 'all_lessons'
  PRIVATE = 'private'
  PUBLIC = 'public'
  LINKED = 'linked'
  ONLY_MINE = 'only_mine'
  NOT_MINE = 'not_mine'
  COPIED = 'copied'
  ALL_MEDIA_ELEMENTS = 'all_media_elements'
  VIDEO = 'video'
  AUDIO = 'audio'
  IMAGE = 'image'
  
  LESSONS_SET = [ALL_LESSONS, PRIVATE, PUBLIC, LINKED, ONLY_MINE, COPIED]
  MEDIA_ELEMENTS_SET = [ALL_MEDIA_ELEMENTS, VIDEO, AUDIO, IMAGE]
  LESSONS_SEARCH_SET = [ALL_LESSONS, NOT_MINE, PUBLIC, ONLY_MINE]
  MEDIA_ELEMENTS_SEARCH_SET = [ALL_MEDIA_ELEMENTS, VIDEO, AUDIO, IMAGE]
  
  CAPTIONS = {
    ALL_LESSONS => I18n.t('filters.all_lessons'),
    PRIVATE => I18n.t('filters.private'),
    PUBLIC => I18n.t('filters.public'),
    LINKED => I18n.t('filters.linked'),
    ONLY_MINE => I18n.t('filters.only_mine'),
    COPIED => I18n.t('filters.copied'),
    ALL_MEDIA_ELEMENTS => I18n.t('filters.all_media_elements'),
    VIDEO => I18n.t('filters.video'),
    AUDIO => I18n.t('filters.audio'),
    IMAGE => I18n.t('filters.image'),
    NOT_MINE => I18n.t('filters.not_mine')
  }
  
end
