Desy::Application.routes.draw do
  
  # MAIN SECTIONS
  get  'dashboard' => 'dashboard#index', :as => :dashboard_index
  get  'lessons' => 'lessons#index', :as => :my_lessons
  get  'media_elements' => 'media_elements#index', :as => :my_media_elements
  get  'virtual_classroom' => 'virtual_classroom#index', :as => :my_virtual_classroom
  
  # LESSONS
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
  
  # MEDIA ELEMENTS
  resources :media_elements, :only => :create
  get  'media_elements/new' => 'media_elements#new', :as => :new_media_elements_editor
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
  get  'lessons/new' => 'lesson_editor#new'
  post 'lessons/create' => 'lesson_editor#create'
  get  'lessons/:lesson_id/slides/edit' => 'lesson_editor#index', :as => :lesson_editor
  get  'lessons/:lesson_id/edit' => 'lesson_editor#edit', :as => :edit_lesson
  put  'lessons/:lesson_id/update' => 'lesson_editor#update', :as => :lesson
  post 'lessons/:lesson_id/slides/:slide_id/kind/:kind/create' => 'lesson_editor#add_slide'
  post 'lessons/:lesson_id/slides/:slide_id/delete' => 'lesson_editor#delete_slide', :as => :delete_slide
  post 'lessons/:lesson_id/slides/:slide_id/update' => 'lesson_editor#save_slide', :as => :save_slide
  post 'lessons/:lesson_id/slides/:slide_id/move/:position' => 'lesson_editor#change_slide_position', :as => :change_slide_position
  
  # GALLERIES
  get  'lessons/galleries/image' => 'galleries#image_for_lesson_editor'
  get  'lessons/galleries/audio' => 'galleries#audio_for_lesson_editor'
  get  'lessons/galleries/video' => 'galleries#video_for_lesson_editor'
  get  'videos/galleries' => 'galleries#mixed_for_video_editor'
  get  'videos/galleries/audio' => 'galleries#audio_for_video_editor'
  get  'audios/galleries/audio' => 'galleries#audio_for_audio_editor'
  get  'images/galleries/image' => 'galleries#image_for_image_editor'
  
  # LESSON VIEWER
  get  'lessons/view/playlist' => 'lesson_viewer#playlist', :as => :lesson_viewer_playlist
  get  'lessons/:lesson_id/view' => 'lesson_viewer#index', :as => :lesson_viewer
  
  # VIRTUAL CLASSROOM
  post 'virtual_classroom/:lesson_id/remove_lesson_from_inside' => 'virtual_classroom#remove_lesson_from_inside'
  post 'virtual_classroom/:lesson_id/add_lesson_to_playlist' => 'virtual_classroom#add_lesson_to_playlist'
  post 'virtual_classroom/:lesson_id/remove_lesson_from_playlist' => 'virtual_classroom#remove_lesson_from_playlist'
  post 'virtual_classroom/:lesson_id/playlist/:position/change_position' => 'virtual_classroom#change_position_in_playlist'
  post 'virtual_classroom/empty_playlist' => 'virtual_classroom#empty_playlist'
  post 'virtual_classroom/empty_virtual_classroom' => 'virtual_classroom#empty_virtual_classroom', :as => :empty_virtual_classroom
  get  'virtual_classroom/select_lessons' => 'virtual_classroom#select_lessons', :as => :select_lessons_for_virtual_classroom
  get  'virtual_classroom/select_lessons_new_block' => 'virtual_classroom#select_lessons_new_block'
  post 'virtual_classroom/load_lessons' => 'virtual_classroom#load_lessons', :as => :load_lessons
  post 'virtual_classroom/:lesson_id/send_link' => 'virtual_classroom#send_link'
  
  # VIDEO EDITOR
  get  'videos/:video_id/edit' => 'video_editor#edit'
  get  'videos/new' => 'video_editor#new'
  get  'videos/cache/restore' => 'video_editor#restore_cache', :as => :video_editor_restore_cache
  post 'videos/cache/save' => 'video_editor#save_cache', :as => :video_editor_save_cache
  post 'videos/cache/empty' => 'video_editor#empty_cache', :as => :video_editor_empty_cache
  post 'videos/commit' => 'video_editor#commit', :as => :video_editor_commit
  
  # AUDIO EDITOR
  get  'audios/:audio_id/edit' => 'audio_editor#index'
  get  'audios/new' => 'audio_editor#index'
  
  # IMAGE EDITOR
  get  'images/:image_id/edit' => 'image_editor#edit'
  post  'images/:image_id/crop' => 'image_editor#crop'
  post  'images/:image_id/save' => 'image_editor#save'
  
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
