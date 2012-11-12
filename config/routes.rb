Desy::Application.routes.draw do
  
  # MAIN SECTIONS
  get  'dashboard' => 'dashboard#index', :as => :dashboard_index
  get  'lessons' => 'lessons#index', :as => :my_lessons
  get  'media_elements' => 'media_elements#index', :as => :my_media_elements
  get  'virtual_classroom' => 'virtual_classroom#index', :as => :my_virtual_classroom
  
  # ACTION BUTTONS FOR LESSONS
  post 'lessons/:lesson_id/add' => 'lessons#add'
  post 'lessons/:lesson_id/copy' => 'lessons#copy'
  post 'lessons/:lesson_id/destroy' => 'lessons#destroy'
  post 'lessons/:lesson_id/dislike' => 'lessons#dislike'
  post 'lessons/:lesson_id/like' => 'lessons#like'
  post 'lessons/:lesson_id/publish' => 'lessons#publish'
  post 'lessons/:lesson_id/remove' => 'lessons#remove'
  post 'lessons/:lesson_id/unpublish' => 'lessons#unpublish'
  post 'virtual_classroom/:lesson_id/add_lesson' => 'virtual_classroom#add_lesson'
  post 'virtual_classroom/:lesson_id/remove_lesson' => 'virtual_classroom#remove_lesson'
  
  # ACTION BUTTONS FOR MEDIA ELEMENTS
  resources :media_elements, :only => :create
  post 'media_elements/:media_element_id/add' => 'media_elements#add'
  post 'media_elements/:media_element_id/destroy' => 'media_elements#destroy'
  post 'media_elements/:media_element_id/remove' => 'media_elements#remove'
  post 'media_elements/:media_element_id/change_info' => 'media_elements#change_info', :as => :change_media_element_info
  
  # NOTIFICATIONS
  post 'notifications/:notification_id/seen' => 'notifications#seen'
  post 'notifications/:notification_id/destroy' => 'notifications#destroy'
  get  'notifications/get_new_block' => 'notifications#get_new_block'
  
  # REPORTS
  post 'reports/lesson' => 'reports#lesson'
  post 'reports/media_element' => 'reports#media_element'
  
  # LESSON EDITOR
  get  'lesson_editor/new' => 'lesson_editor#new'
  post 'lesson_editor/create' => 'lesson_editor#create'
  get  'lesson_editor/:lesson_id/index' => 'lesson_editor#index', :as => :lesson_editor
  get  'lesson_editor/:lesson_id/edit' => 'lesson_editor#edit', :as => :edit_lesson
  put  'lesson_editor/:lesson_id/update' => 'lesson_editor#update', :as => :lesson
  post 'lesson_editor/:current_slide/add_slide/:kind' => 'lesson_editor#add_slide'
  #post 'lesson_editor/:lesson_id/add_slide/:position' => 'lesson_editor#add_slide'
  get  'lesson_editor/add_new_slide/:slide' => 'lesson_editor#add_new_slide', :as => :add_new_slide
  post 'lesson_editor/delete_slide/:slide_id' => 'lesson_editor#delete_slide', :as => :delete_slide
  get  'lesson_editor/show_gallery/:slide' => 'lesson_editor#show_gallery', :as => :show_gallery
  get  'lesson_editor/save_slide' => 'lesson_editor#save_slide', :as => :save_slide
  
  # SEARCH LESSONS OR MEDIA ELEMENTS
  get  'search' => 'search#index', :as => :search_items
  
  # LOGGED USER
  get  'profile' => 'users#edit', :as => :my_profile
  post 'profile/update' => 'users#update'
  get  'logout' => 'users#logout', :as => :logout
  
  # NOT LOGGED USER
  get  'home' => 'prelogin#home', :as => :home
  get  'login' => 'prelogin#login', :as => :login
  get  'sign_up' => 'prelogin#registration', :as => :sign_up
  post 'create_user' => 'prelogin#create_registration', :as => :create_user
  
  # APPLICATION ROOT
  root :to => 'prelogin#home'
  
end
