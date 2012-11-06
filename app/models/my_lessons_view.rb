class MyLessonsView < ActiveRecord::Base
  
  self.table_name = 'my_lessons_view'
  belongs_to :lesson, :foreign_key => "id"

  
end
