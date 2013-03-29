# == Description
#
# ActiveRecord class that corresponds to the table +locations+. The class uses single table inheritance to be divided into different categories: the categories are configured into settings.yml (for each category the application creates a submodel)
#
# == Fields
# 
# * *name*: the name of the location
# * *sti_type*: category to which the location belongs (for example city, region, etc)
# * *ancestry*: list of ancestries of the location. If the location belongs to the top category, this field is +nil+; if it belongs to the second category from the top, the field is a string containing only the id of the parent location; for any other case, the field contains a string with the list top-bottom of all the ancestries of the location (ex. "1/5/13/18")
#
# == Associations
#
# None
#
# == Validations
#
# * *presence* and length of +name+ (maximum 255)
#
# == Callbacks
#
# None
#
# == Database callbacks
#
# None
#
class Location < ActiveRecord::Base
  
  self.inheritance_column = :sti_type
  
  attr_accessible :name, :parent
  
  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  
  has_ancestry
  
  SUBMODELS = SETTINGS['location_types'].map do |type|
    Object.const_set type, Class.new(self)
  end
  
  # === Description
  #
  # This method creates the list of seeds: at this moment the seeds are picked from settings.yml, but it should be possible to change this feature. If the input is an array the methods creates a location for each of its values, otherwise the method assumes that it's a Hash: the locations are created in order of ancestry.
  #
  # === Args
  #
  # * *locations*: an array or a hash of locations
  # * *parent*: the parent of the location
  # * *depth*: the depth where the methods starts
  #
  # === Raises
  #
  # * *submodel does no exist*
  #
  def self.seed!(locations=SETTINGS['locations'], parent=nil, depth=0)
    raise 'submodel does not exist' unless submodel = SUBMODELS[depth]
    if locations.instance_of? Array
      locations.each do |location|
        submodel.create!(name: location, parent: parent)
      end
      return
    end
    locations.map do |name, sublocations|
      [ submodel.create!(name: name, parent: parent), sublocations ]
    end.each do |location, sublocations|
      send __method__, sublocations, location, depth + 1
    end
    nil
  end
  
  # === Description
  #
  # Used in the frontend, to extract the label of the location's category (translated with I18n)
  #
  # === Returns
  #
  # A string
  #
  def label
    index = 0
    SETTINGS['location_types'].each_with_index do |t, i|
      index = i if t == self.sti_type.to_s
    end
    Location.label_at index
  end
  
  # === Description
  #
  # Returns the field +ancestry+, adding to its beginning the id of the current location
  #
  # === Returns
  #
  # A string of ids separated by '/'
  #
  def ancestry_with_me
    anc = self.ancestry
    anc = "#{anc}/" if anc.present? && (/\// =~ anc).nil?
    "#{anc}#{self.id}/"
  end
  
  # === Description
  #
  # Returns the label of the lowest category of location
  #
  # === Returns
  #
  # A string translated with I18n
  #
  def self.base_label
    I18n.t('locations.labels').last
  end
  
  # === Description
  #
  # Returns the label of a chosen category
  #
  # === Args
  #
  # * *index*: the depth of the chosen category
  #
  # === Returns
  #
  # A string translated with I18n
  #
  def self.label_at(index)
    I18n.t('locations.labels')[index]
  end
  
  # === Description
  #
  # Shortcut to return the name of the location
  #
  # === Returns
  #
  # A string
  #
  def to_s
    name.to_s
  end
  
  # === Description
  #
  # Used in the front end, to fill the list of tags +select+ associated to this particular location
  #
  # === Returns
  #
  # An array of strings
  #
  def get_filled_select
    resp = []
    self.ancestors.each do |anc|
      resp << anc.siblings
    end
    resp + [self.siblings]
  end
  
  # === Description
  #
  # Given a hash of parameters with the names of the categories as keys, this method returns the Location corresponding to the last parameter (from parent to son) which is not null. Used in AdminSearchForm.
  #
  # === Args
  #
  # * *params*: a hash which has the names of each category as keys
  #
  # === Returns
  #
  # An object of type Location
  #
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
