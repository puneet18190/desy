class Location < ActiveRecord::Base
  self.inheritance_column = :sti_type
  
  attr_accessible :name, :parent
  
  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  
  has_ancestry
  
  # I sottomodelli di Location sono creati dinamicamente prendendo
  # il valore di SETTINGS['location_types']
  SUBMODELS = SETTINGS['location_types'].map do |type|
    Object.const_set type, Class.new(self)
  end
  
  def self.seed!(locations = SETTINGS['locations'], parent = nil, depth = 0)
    raise 'submodel does not exist' unless submodel = SUBMODELS[depth]
    # se è un array creo le locations per ogni valore di esso
    if locations.instance_of? Array
      locations.each do |location|
        submodel.create!(name: location, parent: parent)
      end
      return
    end
    # se non è un array assumo che sia un Hash; creo la location padre
    # e ricorro passandogliela ed aumentando la profondità
    locations.map do |name, sublocations|
      [ submodel.create!(name: name, parent: parent), sublocations ]
    end.each do |location, sublocations|
      send __method__, sublocations, location, depth+1
    end
    nil
  end
  
  def label
    index = 0
    SETTINGS['location_types'].each_with_index do |t, i|
      index = i if t == self.sti_type.to_s
    end
    Location.label_at index
  end
  
  def ancestry_with_me
    anc = self.ancestry
    anc = "#{anc}/" if anc.present? && (/\// =~ anc).nil?
    "#{anc}#{self.id}/"
  end
  
  def self.base_label
    I18n.t('locations.labels').last
  end
  
  def self.label_at(index)
    I18n.t('locations.labels')[index]
  end
  
  def to_s
    name.to_s
  end
  
  def get_filled_select
    resp = []
    self.ancestors.each do |anc|
      resp << anc.siblings
    end
    resp + [self.siblings]
  end
  
  def self.get_from_chain_params(params)
    flag = true
    index = SETTINGS['location_types'].length - 1
    loc_param = params[SETTINGS['location_types'].last.downcase]
    while flag && index >= 0
      if loc_param.present? && loc_param != '0'
        flag = false
      else
        index -= 1
        loc_param = params[SETTINGS['location_types'][index].downcase]
      end
    end
    Location.find_by_id loc_param
  end
  
end
