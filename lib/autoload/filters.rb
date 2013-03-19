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
  
end
