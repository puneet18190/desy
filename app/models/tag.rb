class Tag < ActiveRecord::Base
  
  MIN_LENGTH = CONFIG['min_tag_length']
  MAX_LENGTH = (CONFIG['max_tag_length'] > 255 ? 255 : CONFIG['max_tag_length'])
  
  attr_accessible :word
  
  has_many :taggings
  
  validates_presence_of :word
  validates_length_of :word, :minimum => MIN_LENGTH, :maximum => MAX_LENGTH
  validates_uniqueness_of :word
  
  before_validation :convert_downcase_word
  
  def self.create_tag_set(type, tagged_id, tags)
    return false if !['Lesson', 'MediaElement'].include? type
    return false if !type.constantize.exists?(tagged_id)
    return false if tags.class != Array || tags.empty?
    return false if CONFIG['force_min_tags_for_item'] && tags.length < CONFIG['min_tags_for_item']
    resp = false
    already_tagged = []
    ActiveRecord::Base.transaction do
      tags.each do |t|
        if t.class == Fixnum
          raise ActiveRecord::Rollback if !Tag.exists?(t)
          old_tagging = Tagging.where(:taggable_type => type, :taggable_id => tagged_id, :tag_id => t).first
          if old_tagging.nil?
            tagging = Tagging.new
            tagging.tag_id = t
            tagging.taggable_type = type
            tagging.taggable_id = tagged_id
            raise ActiveRecord::Rollback if !tagging.save
            already_tagged << tagging.id
          else
            already_tagged << old_tagging.id
          end
        elsif t.class == String
          tag = Tag.new :word => t
          raise ActiveRecord::Rollback if !tag.save
          tagging = Tagging.new
          tagging.tag_id = tag.id
          tagging.taggable_type = type
          tagging.taggable_id = tagged_id
          raise ActiveRecord::Rollback if !tagging.save
          already_tagged << tagging.id
        else
          raise ActiveRecord::Rollback
        end
      end
      Tagging.where('taggable_type = ? AND taggable_id = ? AND id NOT IN (?)', type, tagged_id, already_tagged).each do |tt|
        tt.destroy
      end
      resp = true
    end
    resp
  end
  
  private
  
  def convert_downcase_word
    return if self.word.blank?
    self.word = to_downcase_without_spaces self.word
  end
  
  def to_downcase_without_spaces(x)
    x = x.mb_chars.downcase.to_s
    x = cut_first_spaces(x)
    x.reverse!
    x = cut_first_spaces(x)
    return x.reverse
  end
  
  def cut_first_spaces(x)
    cont = 0
    status = true
    x.each_byte do |byte|
      if byte == 32 && status
        cont += 1
      else
        status = false
      end
    end
    x = x[cont, x.length]
  end
  
end
