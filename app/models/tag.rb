class Tag < ActiveRecord::Base
  
  MIN_LENGTH = CONFIG['min_tag_length']
  MAX_LENGTH = (CONFIG['max_tag_length'] > 255 ? 255 : CONFIG['max_tag_length'])
  
  attr_accessible :word
  
  has_many :taggings
  
  validates_presence_of :word
  validates_length_of :word, :minimum => MIN_LENGTH, :maximum => MAX_LENGTH
  validates_uniqueness_of :word
  
  validate :word_not_changed
  
  before_validation :init_validation
  
  def self.get_tags_for_item(type, id)
    resp = ""
    first_tag = true
    Tagging.where(:taggable_type => type, :taggable_id => id).each do |t|
      if first_tag
        resp = "#{t.tag.word}"
      else
        resp = "#{resp}, #{t.tag.word}"
      end
      first_tag = false
    end
    resp
  end
  
  def self.get_friendly_tags(item_id, kind)
    tags = Tagging.where(:taggable_id => item_id, :taggable_type => kind)
    return '' if tags.empty?
    resp = tags.first.word
    count = 1
    tags.each do |t|
      resp = "#{resp}, #{t.tag.word}" if count == 1
      count += 1
    end
    return resp
  end
  
  def word=(word)
    write_attribute(:word, word.present? ? word.to_s.strip.mb_chars.downcase.to_s : word)
  end
  
  private
  
  def init_validation
    @tag = Valid.get_association self, :id
  end
  
  def word_not_changed
    errors[:word] << "can't be changed" if @tag && @tag.word != self.word
  end
  
end
