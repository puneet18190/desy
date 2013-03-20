class Tag < ActiveRecord::Base
  
  MIN_LENGTH = SETTINGS['min_tag_length']
  MAX_LENGTH = (SETTINGS['max_tag_length'] > 255 ? 255 : SETTINGS['max_tag_length'])
  
  attr_accessible :word
  
  has_many :taggings
  
  validates_presence_of :word
  validates_length_of :word, :minimum => MIN_LENGTH, :maximum => MAX_LENGTH
  validates_uniqueness_of :word
  
  validate :word_not_changed
  
  before_validation :init_validation
  
  def self.get_tags_for_autocomplete(a_word)
    return [] if a_word.blank?
    a_word = a_word.to_s.strip.mb_chars.downcase.to_s
    resp = []
    curr_tag = Tag.find_by_word(a_word)
    limit = SETTINGS['how_many_tags_for_block_in_autocomplete']
    if !curr_tag.nil?
      resp << {:id => curr_tag.id, :value => a_word}
      limit -= 1
    end
    resp += Tag.select('id, word AS value, (SELECT COUNT(*) FROM taggings WHERE (taggings.tag_id = tags.id)) AS tags_count').where('word ILIKE ? AND word != ?', "#{a_word}%", a_word).limit(limit).order('tags_count DESC, value ASC')
    resp
  end
  
  def self.get_tags_for_item(item_id, kind)
    resp = []
    Tagging.includes(:tag).where(:taggable_type => kind, :taggable_id => item_id).order(:tag_id).each do |t|
      resp << t.tag
    end
    resp
  end
  
  def self.get_friendly_tags(item_id, kind)
    tags = Tagging.where(:taggable_id => item_id, :taggable_type => kind).order(:tag_id)
    return '' if tags.empty?
    resp = ",#{tags.first.tag.word}"
    count = 1
    tags.each do |t|
      resp = "#{resp},#{t.tag.word}" if count != 1
      count += 1
    end
    return "#{resp},"
  end
  
  def word=(word)
    write_attribute(:word, word.present? ? word.to_s.strip.mb_chars.downcase.to_s : word)
  end
  
  def to_s
    word.to_s
  end
  
  private
  
  def init_validation
    @tag = Valid.get_association self, :id
  end
  
  def word_not_changed
    errors[:word] << "can't be changed" if @tag && @tag.word != self.word
  end
  
end
