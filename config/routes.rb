Desy::Application.routes.draw do
  
  # FIXME --> TEMPORANEO
  resources :layouts, :only => :show do
    get ':controller_id(/:action_id)' => 'views#show'
  end
  
  # REGISTRATION
  match 'prelogin' => 'registrations#prelogin', :as => :prelogin
  
  # MAIN SECTIONS
  match 'dashboard' => 'dashboard#index', :as => :dashboard_index
  match 'lessons' => 'lessons#index', :as => :my_lessons
  match 'media_elements' => 'media_elements#index', :as => :my_media_elements
  
  # ACTION BUTTONS FOR LESSONS
  match 'lessons/:lesson_id/add' => 'lessons#add', :via => :post
  match 'lessons/:lesson_id/copy' => 'lessons#copy', :via => :post
  match 'lessons/:lesson_id/destroy' => 'lessons#destroy', :via => :post
  match 'lessons/:lesson_id/dislike' => 'lessons#dislike', :via => :post
  match 'lessons/:lesson_id/like' => 'lessons#like', :via => :post
  match 'lessons/:lesson_id/publish' => 'lessons#publish', :via => :post
  match 'lessons/:lesson_id/remove' => 'lessons#remove', :via => :post
  match 'lessons/:lesson_id/unpublish' => 'lessons#unpublish', :via => :post
  match 'virtual_classroom/:lesson_id/add_lesson' => 'virtual_classroom#add_lesson', :via => :post
  match 'virtual_classroom/:lesson_id/remove_lesson' => 'virtual_classroom#remove_lesson', :via => :post
  
  # ACTION BUTTONS FOR MEDIA ELEMENTS
  match 'media_elements/:media_element_id/add' => 'media_elements#add', :via => :post
  match 'media_elements/:media_element_id/destroy' => 'media_elements#destroy', :via => :post
  match 'media_elements/:media_element_id/remove' => 'media_elements#remove', :via => :post
  match 'media_elements/:media_element_id/change_info' => 'media_elements#change_info', :via => :post, :as => :change_media_element_info
  
  # NOTIFICATIONS
  match 'notifications/:notification_id/seen' => 'notifications#seen', :via => :post
  match 'notifications/:notification_id/destroy' => 'notifications#destroy', :via => :post
  match 'notifications/get_new_block' => 'notifications#get_new_block'
  
  # REPORTS
  match 'reports/lesson' => 'reports#lesson', :via => :post
  match 'reports/media_element' => 'reports#media_element', :via => :post
  
  # LESSON EDITOR
  match 'lessons/:lesson_id/edit' => 'lesson_editor#index', :as => :lesson_editor
  
  # APPLICATION ROOT
  root :to => 'registrations#prelogin'
  
end
