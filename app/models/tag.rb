class Tag < ActiveRecord::Base
  
  MIN_LENGTH = VARIABLES['min_tag_length']
  MAX_LENGTH = (VARIABLES['max_tag_length'] > 255 ? 255 : VARIABLES['max_tag_length'])
  
  attr_accessible :word
  
  has_many :taggings
  
  validates_presence_of :word
  validates_length_of :word, :minimum => MIN_LENGTH, :maximum => MAX_LENGTH
  validates_uniqueness_of :word
  
  before_validation :convert_downcase_word
  
  private
  
  def convert_downcase_word
    return if self.word.blank?
    self.word = downcase_international_tag self.word
  end
  
  def downcase_international_tag x
    x.downcase # qui sostituirò il metodo a seconda del linguaggio, da configurare!
  end
  
end
