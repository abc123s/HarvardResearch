Research4::Application.routes.draw do
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"

  resources :submissions
    match '/submissions/new/:jobid', :to => 'submissions#new', :as => "submission_new"
  resources :jobs
  resources :users
    match '/profile/:id', :to => 'users#profile', :as => "user_profile"
  resources :sessions, :only => [:new, :create, :destroy]
    match '/signup/student',  :to => 'users#new0', :as => 'signup0'
    match '/signup/professor', :to => 'users#new1', :as => 'signup1'
    match '/signin/student',  :to => 'sessions#new0', :as => 'signin0'
    match '/signin/professor',  :to => 'sessions#new1', :as => 'signin1'
    match '/signout', :to => 'sessions#destroy', :as => 'signout'
    match '/session/retry/:usertype', :to => 'sessions#create'
    match '/help', :to => 'sessions#new'
  root :to => 'sessions#new'

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
