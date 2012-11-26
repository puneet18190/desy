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
  post 'media_elements/:media_element_id' => 'media_elements#update', :as => :media_element
  post 'media_elements/:media_element_id/add' => 'media_elements#add'
  post 'media_elements/:media_element_id/destroy' => 'media_elements#destroy'
  post 'media_elements/:media_element_id/remove' => 'media_elements#remove'
  
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
  post 'lesson_editor/:lesson_id/add_slide/:slide_id/kind/:kind' => 'lesson_editor#add_slide'
  post 'lesson_editor/:lesson_id/delete_slide/:slide_id' => 'lesson_editor#delete_slide', :as => :delete_slide
  get  'lesson_editor/:lesson_id/show_gallery/:slide_id' => 'lesson_editor#show_gallery', :as => :show_gallery
  get  'lesson_editor/:lesson_id/save_slide/:slide_id' => 'lesson_editor#save_slide', :as => :save_slide
  post 'lesson_editor/:lesson_id/change_slide_position/:slide_id/position/:position' => 'lesson_editor#change_slide_position', :as => :change_slide_position
  
  # LESSON VIEWER
  get  'lesson_viewer/playlist' => 'lesson_viewer#playlist', :as => :lesson_viewer_playlist
  get  'lesson_viewer/:lesson_id/show' => 'lesson_viewer#index', :as => :lesson_viewer
  
  # VIRTUAL CLASSROOM
  post 'virtual_classroom/:lesson_id/remove_lesson_from_inside' => 'virtual_classroom#remove_lesson_from_inside'
  post 'virtual_classroom/:lesson_id/add_lesson_to_playlist' => 'virtual_classroom#add_lesson_to_playlist'
  post 'virtual_classroom/:lesson_id/remove_lesson_from_playlist' => 'virtual_classroom#remove_lesson_from_playlist'
  post 'virtual_classroom/:lesson_id/playlist/:position/change_position' => 'virtual_classroom#change_position_in_playlist'
  post 'virtual_classroom/empty_playlist' => 'virtual_classroom#empty_playlist'
  post 'virtual_classroom/empty_virtual_classroom' => 'virtual_classroom#empty_virtual_classroom', :as => :empty_virtual_classroom
  get  'virtual_classroom/select_lessons' => 'virtual_classroom#select_lessons', :as => :select_lessons_for_virtual_classroom
  get  'virtual_classroom/select_lessons_new_block' => 'virtual_classroom#select_lessons_new_block'
  post 'virtual_classroom/load_lessons' => 'virtual_classroom#load_lessons'
  post 'virtual_classroom/:lesson_id/send_link' => 'virtual_classroom#send_link'
  
  # MEDIA ELEMENTS EDITOR
  get  'media_elements_editor/' => 'media_elements_editor#index'
  get  'media_elements_editor/show_gallery/' => 'media_elements_editor#show_gallery', :as => :show_gallery
  
  # BASE64 TO IMAGE
  post 'base64_to_image/' => "base64_to_image#create"
  get 'base64_to_image_test' => "base64_to_image#test"
  
  # SEARCH LESSONS OR MEDIA ELEMENTS
  get  'search' => 'search#index', :as => :search_items
  
  # LOGGED USER
  get  'profile' => 'users#edit', :as => :my_profile
  post 'profile/update' => 'users#update'
  get  'logout' => 'users#logout', :as => :logout
  
  # USER NOT LOGGED
  get  'home' => 'prelogin#home', :as => :home
  get  'login' => 'prelogin#login', :as => :login
  get  'sign_up' => 'prelogin#registration', :as => :sign_up
  get  'what_is_desy' => 'prelogin#what_is_desy', :as => :what_is_desy
  get  'contact_us' => 'prelogin#contact_us', :as => :contact_us
  post 'create_user' => 'prelogin#create_registration', :as => :create_user
  
  # APPLICATION ROOT
  root :to => 'prelogin#home'
  
end
