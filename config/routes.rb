Desy::Application.routes.draw do
  
  # MAIN SECTIONS
  get  'dashboard'         => 'dashboard#index',         :as => :dashboard
  get  'lessons'           => 'lessons#index',           :as => :my_lessons
  get  'media_elements'    => 'media_elements#index',    :as => :my_media_elements
  get  'virtual_classroom' => 'virtual_classroom#index', :as => :my_virtual_classroom
  
  # LESSONS
  post 'lessons/:lesson_id/add'                      => 'lessons#add'
  post 'lessons/:lesson_id/copy'                     => 'lessons#copy'
  post 'lessons/:lesson_id/destroy'                  => 'lessons#destroy'
  post 'lessons/:lesson_id/dislike'                  => 'lessons#dislike'
  post 'lessons/:lesson_id/like'                     => 'lessons#like'
  post 'lessons/:lesson_id/publish'                  => 'lessons#publish'
  post 'lessons/:lesson_id/remove'                   => 'lessons#remove'
  post 'lessons/:lesson_id/unpublish'                => 'lessons#unpublish'
  post 'lessons/:lesson_id/notify_modification'      => 'lessons#notify_modification'
  post 'lessons/:lesson_id/dont_notify_modification' => 'lessons#dont_notify_modification'
  post 'virtual_classroom/:lesson_id/add_lesson'     => 'virtual_classroom#add_lesson'
  post 'virtual_classroom/:lesson_id/remove_lesson'  => 'virtual_classroom#remove_lesson'
  
  # MEDIA ELEMENTS
  resources :media_elements,                     :only => :create
  get       'media_elements/new'                       => 'media_elements#new',    :as => :new_media_elements_editor
  post      'media_elements/:media_element_id'         => 'media_elements#update', :as => :media_element
  post      'media_elements/:media_element_id/add'     => 'media_elements#add'
  post      'media_elements/:media_element_id/destroy' => 'media_elements#destroy'
  post      'media_elements/:media_element_id/remove'  => 'media_elements#remove'
  
  # NOTIFICATIONS
  post 'notifications/:notification_id/seen'    => 'notifications#seen'
  post 'notifications/:notification_id/destroy' => 'notifications#destroy'
  get  'notifications/get_new_block'            => 'notifications#get_new_block'
  
  # REPORTS
  post 'reports/lesson'        => 'reports#lesson'
  post 'reports/media_element' => 'reports#media_element'
  
  # LESSON EDITOR
  get  'lessons/new'                                           => 'lesson_editor#new'
  post 'lessons/create'                                        => 'lesson_editor#create'
  get  'lessons/:lesson_id/slides/edit'                        => 'lesson_editor#index',                 :as => :lesson_editor
  get  'lessons/:lesson_id/edit'                               => 'lesson_editor#edit',                  :as => :edit_lesson
  put  'lessons/:lesson_id/update'                             => 'lesson_editor#update',                :as => :lesson
  post 'lessons/:lesson_id/slides/:slide_id/kind/:kind/create' => 'lesson_editor#add_slide'
  post 'lessons/:lesson_id/slides/:slide_id/delete'            => 'lesson_editor#delete_slide',          :as => :delete_slide
  post 'lessons/:lesson_id/slides/:slide_id/update'            => 'lesson_editor#save_slide',            :as => :save_slide
  post 'lessons/:lesson_id/slides/:slide_id/move/:position'    => 'lesson_editor#change_slide_position', :as => :change_slide_position
  get  'lessons/:lesson_id/slides/:slide_id/load'              => 'lesson_editor#load_slide'
  
  # TAGS
  get 'tags/get_list'             => 'tags#get_list'
  get 'tags/:word/check_presence' => 'tags#check_presence'
  
  # GALLERIES
  get 'lessons/galleries/image'           => 'galleries#image_for_lesson_editor' # image in lesson editor
  get 'lessons/galleries/image/new_block' => 'galleries#image_for_lesson_editor_new_block'
  get 'lessons/galleries/audio'           => 'galleries#audio_for_lesson_editor' # audio in lesson editor
  get 'lessons/galleries/audio/new_block' => 'galleries#audio_for_lesson_editor_new_block'
  get 'lessons/galleries/video'           => 'galleries#video_for_lesson_editor' # video in lesson editor
  get 'lessons/galleries/video/new_block' => 'galleries#video_for_lesson_editor_new_block'
  get 'videos/galleries'                  => 'galleries#mixed_for_video_editor' # mixed image + video + text in video editor
  get 'videos/galleries/image/new_block'  => 'galleries#mixed_for_video_editor_image_new_block'
  get 'videos/galleries/video/new_block'  => 'galleries#mixed_for_video_editor_video_new_block'
  get 'videos/galleries/audio'            => 'galleries#audio_for_video_editor' # audio in video editor
  get 'videos/galleries/audio/new_block'  => 'galleries#audio_for_video_editor_new_block'
  get 'audios/galleries/audio'            => 'galleries#audio_for_audio_editor' # audio in audio editor
  get 'audios/galleries/audio/new_block'  => 'galleries#audio_for_audio_editor_new_block'
  get 'images/galleries/image'            => 'galleries#image_for_image_editor' # image in image editor
  get 'images/galleries/image/new_block'  => 'galleries#image_for_image_editor_new_block'
  
  # LESSON VIEWER
  get  'lessons/view/playlist'                         => 'lesson_viewer#playlist', :as => :lesson_viewer_playlist
  get  'lessons/:lesson_id/view'                       => 'lesson_viewer#index',    :as => :lesson_viewer
  get  'lessons/:lesson_id/view/slides/:slide_id/load' => 'lesson_viewer#load_slide'
  
  # VIRTUAL CLASSROOM
  post 'virtual_classroom/:lesson_id/remove_lesson_from_inside'          => 'virtual_classroom#remove_lesson_from_inside'
  post 'virtual_classroom/:lesson_id/add_lesson_to_playlist'             => 'virtual_classroom#add_lesson_to_playlist'
  post 'virtual_classroom/:lesson_id/remove_lesson_from_playlist'        => 'virtual_classroom#remove_lesson_from_playlist'
  post 'virtual_classroom/:lesson_id/playlist/:position/change_position' => 'virtual_classroom#change_position_in_playlist'
  post 'virtual_classroom/empty_playlist'                                => 'virtual_classroom#empty_playlist'
  post 'virtual_classroom/empty_virtual_classroom'                       => 'virtual_classroom#empty_virtual_classroom', :as => :empty_virtual_classroom
  get  'virtual_classroom/select_lessons'                                => 'virtual_classroom#select_lessons',          :as => :select_lessons_for_virtual_classroom
  get  'virtual_classroom/select_lessons_new_block'                      => 'virtual_classroom#select_lessons_new_block'
  post 'virtual_classroom/load_lessons'                                  => 'virtual_classroom#load_lessons',            :as => :load_lessons
  post 'virtual_classroom/:lesson_id/send_link'                          => 'virtual_classroom#send_link'
  
  # VIDEO EDITOR
  get  'videos/:video_id/edit'   => 'video_editor#edit'
  get  'videos/new'              => 'video_editor#new'
  get  'videos/cache/restore'    => 'video_editor#restore_cache', :as => :video_editor_restore_cache
  post 'videos/cache/save'       => 'video_editor#save_cache',    :as => :video_editor_save_cache
  post 'videos/cache/empty'      => 'video_editor#empty_cache',   :as => :video_editor_empty_cache
  post 'videos/commit/new'       => 'video_editor#save'
  post 'videos/commit/overwrite' => 'video_editor#overwrite'
  
  # AUDIO EDITOR
  get  'audios/:audio_id/edit'   => 'audio_editor#edit'
  get  'audios/new'              => 'audio_editor#new'
  get  'audios/cache/restore'    => 'audio_editor#restore_cache', :as => :audio_editor_restore_cache
  post 'audios/cache/save'       => 'audio_editor#save_cache',    :as => :audio_editor_save_cache
  post 'audios/cache/empty'      => 'audio_editor#empty_cache',   :as => :audio_editor_empty_cache
  post 'audios/commit/new'       => 'audio_editor#save'
  post 'audios/commit/overwrite' => 'audio_editor#overwrite'
  
  # IMAGE EDITOR
  get  'images/:image_id/edit'             => 'image_editor#edit'
  post 'images/:image_id/crop'             => 'image_editor#crop'
  post 'images/:image_id/add_text'         => 'image_editor#add_text'
  post 'images/:image_id/undo'             => 'image_editor#undo'
  post 'images/:image_id/commit/new'       => 'image_editor#save'
  post 'images/:image_id/commit/overwrite' => 'image_editor#overwrite'
  
  # SEARCH LESSONS OR MEDIA ELEMENTS
  get 'search' => 'search#index', :as => :search_items
  
  # LOGGED USER
  get  'profile'               => 'users#edit',          :as => :my_profile
  get  'profile/subjects'      => 'users#subjects',      :as => :my_subjects
  get  'profile/statistics'    => 'users#statistics',    :as => :my_statistics
  get  'profile/mailing_lists' => 'users#mailing_lists', :as => :my_mailing_lists
  put  'profile/update'        => 'users#update',        :as => :user
  post 'location/:id/find'     => 'users#find_location'
  
  # MAILING LIST
  post   'mailing_lists/create'                                 => 'mailing_lists#create_group'
  put    'mailing_lists/:group_id/update/:name'                 => 'mailing_lists#update_group'
  post   'mailing_lists/:group_id/addresses/create'             => 'mailing_lists#create_address', :as => :add_new_address_to_group
  delete 'mailing_lists/:group_id/delete'                       => 'mailing_lists#delete_group'
  delete 'mailing_lists/:group_id/addresses/:address_id/delete' => 'mailing_lists#delete_address'
  
  # USER SESSION
  post   'users_sessions' => 'users/sessions#create'
  delete 'users_session'  => 'users/sessions#destroy'
  
  # USER NOT LOGGED
  get  'home'                 => 'prelogin#home',                :as => :home
  get  'sign_up'              => 'prelogin#registration',        :as => :sign_up
  post 'sign_up'              => 'users#create',                 :as => :users
  get  'users/confirm/:token' => 'users#confirm',                :as => :user_confirm
  get  'users/password'       => 'users#request_reset_password', :as => :user_request_reset_password
  post 'users/password'       => 'users#reset_password',         :as => :user_reset_password
  get  'what_is_desy'         => 'prelogin#what_is_desy',        :as => :what_is_desy
  
  # APPLICATION ROOT
  root :to => 'prelogin#home'
  
  # ADMINISTRATION SECTION
  namespace 'admin' do
    root      :to                                       => 'dashboard#index'
    get       'users/get_full_names'                    => 'users#get_full_names'
    put       'users/:id/set_status'                    => 'users#set_status'
    put       'user/:id/activate'                       => 'users#activate'
    put       'user/:id/ban'                            => 'users#ban'
    get       'media_elements/edit'                     => 'media_elements#edit'
    get       'media_elements/:id/load'                 => 'media_elements#load_media_element'
    post      'media_elements/quick_upload'             => 'media_elements#quick_upload'
    post      'media_elements/:key/create'              => 'media_elements#create'
    delete    'media_elements/quick_upload/:key/delete' => 'media_elements#quick_upload_delete'
    put       'media_elements/:media_element_id/update' => 'media_elements#update'
    post      'locations/:id/find'                      => 'users#find_locations'
    get       'messages/new_notification'               => 'messages#new_notification'
    post      'messages/send_notifications'             => 'messages#send_notifications'
    get       'messages/reports'                        => 'messages#reports'
    post      'messages/filter_users'                   => 'messages#filter_users'
    resources :lessons,                           :only => [:index, :destroy]
    resources :media_elements,                    :only => [:new, :index, :destroy]
    resources :users,                             :only => [:index, :show, :destroy]
  end
  
  # 404
  match '*path', to: 'application#page_not_found' unless Rails.application.config.consider_all_requests_local
  
end
