require 'recursive_open_struct'

STATUSES = RecursiveOpenStruct.new({
  :lessons => {
    :private => I18n.t('status.lessons.private'),
    :copied => I18n.t('status.lessons.copied'),
    :linked => I18n.t('status.lessons.linked'),
    :shared => I18n.t('status.lessons.shared'),
    :public => I18n.t('status.lessons.public')
  },
  :media_elements => {
    :private => I18n.t('status.media_elements.private'),
    :linked => I18n.t('status.media_elements.linked'),
    :public => I18n.t('status.media_elements.public')
  }
})
