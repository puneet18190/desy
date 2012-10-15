Desy::Application.routes.draw do

  resources :layouts, :only => :show do
    get ':controller_id(/:action_id)' => 'views#show'
    # resources :views, :only => :show
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
  match 'lessons/:lesson_id/like' => 'lessons#like', :via => :post
  match 'lessons/:lesson_id/publish' => 'lessons#publish', :via => :post
  match 'lessons/:lesson_id/remove' => 'lessons#remove', :via => :post
  match 'lessons/:lesson_id/report' => 'lessons#report', :via => :post
  match 'lessons/:lesson_id/unpublish' => 'lessons#unpublish', :via => :post
  match 'virtual_classroom/:lesson_id/add_lesson' => 'virtual_classroom#add_lesson', :via => :post
  match 'virtual_classroom/:lesson_id/remove_lesson' => 'virtual_classroom#remove_lesson', :via => :post
  
  # ACTION BUTTONS FOR MEDIA ELEMENTS
  match 'media_elements/:media_element_id/add' => 'media_elements#add', :via => :post
  match 'media_elements/:media_element_id/destroy' => 'media_elements#destroy', :via => :post
  match 'media_elements/:media_element_id/remove' => 'media_elements#remove', :via => :post
  match 'media_elements/:media_element_id/report' => 'media_elements#report', :via => :post
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
