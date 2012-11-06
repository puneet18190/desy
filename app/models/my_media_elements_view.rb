class MyMediaElementsView < ActiveRecord::Base
  
  self.table_name = 'my_media_elements_view'
  belongs_to :media_element, :foreign_key => "id"
  
end
