Desy::Application.routes.draw do
  
  root :to => 'prelogin#home'
  
  namespace 'admin' do
    root   :to                                       => 'dashboard#index'
    
    # ADMIN DOCUMENTS
    get    'documents'     => 'documents#index',   :as => :documents
    delete 'documents/:id' => 'documents#destroy', :as => :document
    
    # ADMIN LESSONS
    get    'lessons'     => 'lessons#index',   :as => :lessons
    delete 'lessons/:id' => 'lessons#destroy', :as => :lesson
    
    # ADMIN MEDIA ELEMENTS
    get    'media_elements'                          => 'media_elements#index',              :as => :media_elements
    get    'media_elements/edit'                     => 'media_elements#edit'
    delete 'media_elements/:id'                      => 'media_elements#destroy',            :as => :media_element
    get    'media_elements/:id/load'                 => 'media_elements#load_media_element'
    post   'media_elements/:key/create'              => 'media_elements#create'
    put    'media_elements/:media_element_id/update' => 'media_elements#update'
    get    'media_elements/new'                      => 'media_elements#new'
    post   'media_elements/quick_upload'             => 'media_elements#quick_upload'
    delete 'media_elements/quick_upload/:key/delete' => 'media_elements#quick_upload_delete'
    
    # ADMIN MESSAGES
    post 'messages/filter_users'     => 'messages#filter_users'
    get  'messages/new_notification' => 'messages#new_notification', :as => :messages_new_notification
    get  'messages/reports'          => 'messages#reports'
    
    # ADMIN PERSONIFICATIONS
    delete 'personifications'     => 'personifications#destroy', :as => :personification
    post   'personifications/:id' => 'personifications#create',  :as => :personifications
    
    # ADMIN PURCHASES
    get  'purchases'                => 'purchases#index',    :as => :purchases
    post 'purchases'                => 'purchases#create'
    put  'purchases/:id'            => 'purchases#update',   :as => :purchase
    get  'purchases/:id/edit'       => 'purchases#edit'
    get  'purchases/:id/links/form' => 'purchases#link_form'
    post 'purchases/:id/links/send' => 'purchases#send_link'
    get  'purchases/new'            => 'purchases#new'
    
    # ADMIN REPORTS
    delete 'reports/:id/accept'  => 'reports#accept'
    delete 'reports/:id/decline' => 'reports#decline'
    
    # ADMIN SETTINGS
    get    'settings/locations'                    => 'settings#locations'
    post   'settings/locations/create'             => 'settings#create_location'
    put    'settings/locations/:id/update'         => 'settings#update_location'
    get    'settings/school_levels'                => 'settings#school_levels'
    delete 'settings/school_levels/:id/delete'     => 'settings#delete_school_level'
    post   'settings/school_levels/new'            => 'settings#new_school_level'
    get    'settings/subjects'                     => 'settings#subjects'
    delete 'settings/subjects/:id/delete'          => 'settings#delete_subject'
    post   'settings/subjects/new'                 => 'settings#new_subject'
    get    'settings/tags'                         => 'settings#tags'
    delete 'settings/tags/:id/delete'              => 'settings#delete_tag'
    get    'settings/tags/:id/show/lessons'        => 'settings#lessons_for_tag'
    get    'settings/tags/:id/show/media_elements' => 'settings#media_elements_for_tag'
    
    # ADMIN USERS
    get    'users'                => 'users#index',         :as => :users
    get    'users/get_full_names' => 'users#get_full_names'
    delete 'users/:id'            => 'users#destroy'
    get    'users/:id'            => 'users#show',          :as => :user
    put    'users/:id/activate'   => 'users#activate',      :as => :users_activate
    put    'users/:id/ban'        => 'users#ban',           :as => :users_ban
    put    'users/:id/set_status' => 'users#set_status'
    
  end
  
  # AUDIO EDITOR
  get  'audios/:audio_id/edit'   => 'audio_editor#edit'
  post 'audios/cache/empty'      => 'audio_editor#empty_cache',   :as => :audio_editor_empty_cache
  get  'audios/cache/restore'    => 'audio_editor#restore_cache', :as => :audio_editor_restore_cache
  post 'audios/cache/save'       => 'audio_editor#save_cache',    :as => :audio_editor_save_cache
  post 'audios/commit/new'       => 'audio_editor#save'
  post 'audios/commit/overwrite' => 'audio_editor#overwrite'
  get  'audios/new'              => 'audio_editor#new'
  
  # DASHBOARD
  get 'dashboard/lessons'        => 'dashboard#lessons',        :as => :dashboard_lessons
  get 'dashboard/media_elements' => 'dashboard#media_elements', :as => :dashboard_media_elements
  
  # DOCUMENTS
  post   'documents'              => 'documents#create',     :as => :documents
  get    'documents/create/fake'  => 'documents#create_fake'
  delete 'documents/:document_id' => 'documents#destroy'
  post   'documents/:document_id' => 'documents#update',     :as => :document
  
  # FAQS
  get 'faqs'                               => 'faqs#index',             :as => :faqs
  get 'faqs/lessons/:num/answer'           => 'faqs#lessons',           :as => :lessons_faqs
  get 'faqs/media_elements/:num/answer'    => 'faqs#media_elements',    :as => :media_elements_faqs
  get 'faqs/profile/:num/answer'           => 'faqs#profile',           :as => :profile_faqs
  get 'faqs/virtual_classroom/:num/answer' => 'faqs#virtual_classroom', :as => :virtual_classroom_faqs
  
  # GALLERIES
  get 'audios/galleries/audio'               => 'galleries#audio_for_audio_editor' # audio in audio editor
  get 'audios/galleries/audio/new_block'     => 'galleries#audio_for_audio_editor_new_block'
  get 'images/galleries/image'               => 'galleries#image_for_image_editor' # image in image editor
  get 'images/galleries/image/new_block'     => 'galleries#image_for_image_editor_new_block'
  get 'lessons/galleries/audio'              => 'galleries#audio_for_lesson_editor' # audio in lesson editor
  get 'lessons/galleries/audio/new_block'    => 'galleries#audio_for_lesson_editor_new_block'
  get 'lessons/galleries/document'           => 'galleries#document_for_lesson_editor' # documents in lesson editor
  get 'lessons/galleries/document/filter'    => 'galleries#document_for_lesson_editor_filter'
  get 'lessons/galleries/document/new_block' => 'galleries#document_for_lesson_editor_new_block'
  get 'lessons/galleries/image'              => 'galleries#image_for_lesson_editor' # image in lesson editor
  get 'lessons/galleries/image/new_block'    => 'galleries#image_for_lesson_editor_new_block'
  get 'lessons/galleries/video'              => 'galleries#video_for_lesson_editor' # video in lesson editor
  get 'lessons/galleries/video/new_block'    => 'galleries#video_for_lesson_editor_new_block'
  get 'videos/galleries'                     => 'galleries#mixed_for_video_editor' # mixed image + video + text in video editor
  get 'videos/galleries/audio'               => 'galleries#audio_for_video_editor' # audio in video editor
  get 'videos/galleries/audio/new_block'     => 'galleries#audio_for_video_editor_new_block'
  get 'videos/galleries/image/new_block'     => 'galleries#mixed_for_video_editor_image_new_block'
  get 'videos/galleries/video/new_block'     => 'galleries#mixed_for_video_editor_video_new_block'
  
  
  
  
  
  
  # GALLERIES QUICK UPLOAD
  post 'lessons/galleries/images'                     => 'galleries#create_image'
  post 'lessons/galleries/audios'                     => 'galleries#create_audio'
  post 'lessons/galleries/videos'                     => 'galleries#create_video'
  post 'lessons/galleries/documents'                  => 'galleries#create_document'
  get  'lessons/galleries/media_elements/create/fake' => 'galleries#create_fake_media_element'
  get  'lessons/galleries/documents/create/fake'      => 'galleries#create_fake_document'
  
  # IMAGE EDITOR
  get  'images/:image_id/edit'             => 'image_editor#edit'
  post 'images/:image_id/crop'             => 'image_editor#crop'
  post 'images/:image_id/add_text'         => 'image_editor#add_text'
  post 'images/:image_id/undo'             => 'image_editor#undo'
  post 'images/:image_id/commit/new'       => 'image_editor#save'
  post 'images/:image_id/commit/overwrite' => 'image_editor#overwrite'
  
  # LESSON BUTTONS
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
  
  # LESSON EDITOR
  get  'lessons/new'                                           => 'lesson_editor#new',                   :as => :new_lesson
  post 'lessons/create'                                        => 'lesson_editor#create'
  get  'lessons/:lesson_id/slides/edit'                        => 'lesson_editor#index',                 :as => :lesson_editor
  get  'lessons/:lesson_id/edit'                               => 'lesson_editor#edit',                  :as => :edit_lesson
  put  'lessons/:lesson_id/update'                             => 'lesson_editor#update',                :as => :lesson
  post 'lessons/:lesson_id/slides/:slide_id/kind/:kind/create' => 'lesson_editor#add_slide'
  post 'lessons/:lesson_id/slides/:slide_id/delete'            => 'lesson_editor#delete_slide',          :as => :delete_slide
  post 'lessons/:lesson_id/slides/:slide_id/update'            => 'lesson_editor#save_slide',            :as => :save_slide
  post 'lessons/:lesson_id/slides/:slide_id/update_and_exit'   => 'lesson_editor#save_slide_and_exit'
  post 'lessons/:lesson_id/slides/:slide_id/update_and_edit'   => 'lesson_editor#save_slide_and_edit'
  post 'lessons/:lesson_id/slides/:slide_id/move/:position'    => 'lesson_editor#change_slide_position', :as => :change_slide_position
  get  'lessons/:lesson_id/slides/:slide_id/load'              => 'lesson_editor#load_slide'
  
  # LESSON EXPORT
  get 'lessons/:lesson_id/archive' => 'lesson_export#archive', :as => :lesson_archive
  get 'lessons/:lesson_id/ebook'   => 'lesson_export#ebook',   :as => :lesson_ebook
  get 'lessons/:lesson_id/scorm'   => 'lesson_export#scorm',   :as => :lesson_scorm
  
  # LESSON VIEWER
  get 'lessons/view/playlist'   => 'lesson_viewer#playlist', :as => :lesson_viewer_playlist
  get 'lessons/:lesson_id/view' => 'lesson_viewer#index',    :as => :lesson_viewer
  
  # LOCATIONS
  get 'locations/toggle'                   => 'users#toggle_locations'
  get 'locations/:id/find'                 => 'users#find_locations'
  get 'admin/locations/:id/find'           => 'admin/users#find_locations'
  get 'admin/purchases/locations/:id/find' => 'admin/purchases#find_locations'
  get 'admin/purchases/locations/fill'     => 'admin/purchases#fill_locations'
  
  # LOGGED USER
  get 'profile'                 => 'users#edit',            :as => :my_profile
  get 'profile/subjects'        => 'users#subjects',        :as => :my_subjects
  get 'profile/statistics'      => 'users#statistics',      :as => :my_statistics
  get 'profile/mailing_lists'   => 'users#mailing_lists',   :as => :my_mailing_lists
  get 'profile/trial'           => 'users#trial',           :as => :my_trial
  put 'profile/update'          => 'users#update',          :as => :user
  put 'profile/subjects/update' => 'users#update_subjects', :as => :user_subjects
  
  # MAILING LISTS
  post   'mailing_lists/create'                                 => 'mailing_lists#create_group'
  put    'mailing_lists/:group_id/update/:name'                 => 'mailing_lists#update_group'
  post   'mailing_lists/:group_id/addresses/create'             => 'mailing_lists#create_address', :as => :add_new_address_to_group
  delete 'mailing_lists/:group_id/delete'                       => 'mailing_lists#delete_group'
  delete 'mailing_lists/:group_id/addresses/:address_id/delete' => 'mailing_lists#delete_address'
  
  # MAIN MENU
  get 'dashboard'         => 'dashboard#index',         :as => :dashboard
  get 'lessons'           => 'lessons#index',           :as => :my_lessons
  get 'media_elements'    => 'media_elements#index',    :as => :my_media_elements
  get 'virtual_classroom' => 'virtual_classroom#index', :as => :my_virtual_classroom
  get 'documents'         => 'documents#index',         :as => :my_documents
  
  # MEDIA ELEMENT BUTTONS
  post 'media_elements'                                => 'media_elements#create',          :as => :media_elements
  get  'media_elements/create/fake'                    => 'media_elements#create_fake'
  get  'media_elements/new'                            => 'media_elements#new',             :as => :new_media_elements_editor
  post 'media_elements/:media_element_id'              => 'media_elements#update',          :as => :media_element
  post 'media_elements/:media_element_id/add'          => 'media_elements#add'
  post 'media_elements/:media_element_id/destroy'      => 'media_elements#destroy'
  post 'media_elements/:media_element_id/destroy/fake' => 'media_elements#destroy_fake'
  post 'media_elements/:media_element_id/remove'       => 'media_elements#remove'
  get  'media_elements/:media_element_id/preview/load' => 'media_elements#load_preview'
  get  'media_elements/conversion/check'               => 'media_elements#check_conversion'
  
  # NOTIFICATIONS
  post 'notifications/:notification_id/seen'    => 'notifications#seen'
  post 'notifications/:notification_id/destroy' => 'notifications#destroy'
  get  'notifications/get_new_block'            => 'notifications#get_new_block'
  get  'notifications/reload'                   => 'notifications#reload'
  
  # REPORTS
  post 'reports/lesson'        => 'reports#lesson'
  post 'reports/media_element' => 'reports#media_element'
  
  # SEARCH ENGINE
  get 'search' => 'search#index', :as => :search_items
  
  # TAGS
  get 'tags/get_list'             => 'tags#get_list'
  get 'tags/:word/check_presence' => 'tags#check_presence'
  
  # USER NOT LOGGED
  get  'what_is'                     => 'prelogin#what_is',             :as => :what_is
  get  'sign_up'                     => 'prelogin#registration',        :as => :sign_up
  post 'sign_up'                     => 'users#create',                 :as => :users
  get  'users/confirm/:token'        => 'users#confirm',                :as => :user_confirm
  get  'users/password'              => 'users#request_reset_password', :as => :user_request_reset_password
  post 'users/password/send'         => 'users#send_reset_password',    :as => :user_send_reset_password
  get  'users/password/reset/:token' => 'users#reset_password',         :as => :user_reset_password
  get  'users/upgrade_trial'         => 'users#request_upgrade_trial',  :as => :user_request_upgrade_trial
  post 'users/upgrade_trial'         => 'users#send_upgrade_trial',     :as => :user_send_upgrade_trial
  post 'users/upgrade_trial/logged'  => 'users#logged_upgrade_trial',   :as => :user_logged_upgrade_trial
  get  'sign_up/purchase_code'       => 'prelogin#purchase_code',       :as => :match_purchase_code
  
  # USER SESSIONS
  post   'users_sessions' => 'users/sessions#create'
  delete 'users_session'  => 'users/sessions#destroy'
  
  # UTILITIES
  get  ':locale'               => 'application#set_locale', constraints: { locale: /(en|cn|it)/ } if Rails.application.config.more_than_one_language
  if SETTINGS['media_test']
    get  'videos_test'         => 'media_elements#videos_test'
    get  'audios_test'         => 'media_elements#audios_test'
  end
  post 'browser_not_supported' => 'application#browser_not_supported'
  match '*path',           :to => 'application#page_not_found' unless Rails.application.config.consider_all_requests_local
  
  # VIDEO EDITOR
  get  'videos/:video_id/edit'   => 'video_editor#edit'
  get  'videos/new'              => 'video_editor#new'
  get  'videos/cache/restore'    => 'video_editor#restore_cache', :as => :video_editor_restore_cache
  post 'videos/cache/save'       => 'video_editor#save_cache',    :as => :video_editor_save_cache
  post 'videos/cache/empty'      => 'video_editor#empty_cache',   :as => :video_editor_empty_cache
  post 'videos/commit/new'       => 'video_editor#save'
  post 'videos/commit/overwrite' => 'video_editor#overwrite'
  
  # VIRTUAL CLASSROOM
  post 'virtual_classroom/:lesson_id/remove_lesson_from_inside'          => 'virtual_classroom#remove_lesson_from_inside'
  post 'virtual_classroom/:lesson_id/add_lesson_to_playlist'             => 'virtual_classroom#add_lesson_to_playlist'
  post 'virtual_classroom/:lesson_id/remove_lesson_from_playlist'        => 'virtual_classroom#remove_lesson_from_playlist'
  post 'virtual_classroom/:lesson_id/playlist/:position/change_position' => 'virtual_classroom#change_position_in_playlist'
  post 'virtual_classroom/empty_playlist'                                => 'virtual_classroom#empty_playlist'
  post 'virtual_classroom/empty_virtual_classroom'                       => 'virtual_classroom#empty_virtual_classroom'
  get  'virtual_classroom/select_lessons'                                => 'virtual_classroom#select_lessons'
  get  'virtual_classroom/select_lessons_new_block'                      => 'virtual_classroom#select_lessons_new_block'
  post 'virtual_classroom/load_lessons'                                  => 'virtual_classroom#load_lessons',               :as => :load_lessons
  post 'virtual_classroom/:lesson_id/send_link'                          => 'virtual_classroom#send_link'
  
end
