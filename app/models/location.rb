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

  def to_s
    name.to_s
  end
  
end
