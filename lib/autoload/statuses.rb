require 'recursive_open_struct'

STATUSES = RecursiveOpenStruct.new({
  :lessons => {
    :private => I18n.t('statuses.lessons.private'),
    :copied => I18n.t('statuses.lessons.copied'),
    :linked => I18n.t('statuses.lessons.linked'),
    :shared => I18n.t('statuses.lessons.shared'),
    :public => I18n.t('statuses.lessons.public')
  },
  :media_elements => {
    :private => I18n.t('statuses.media_elements.private'),
    :linked => I18n.t('statuses.media_elements.linked'),
    :public => I18n.t('statuses.media_elements.public')
  }
})
