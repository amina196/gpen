GpenApp::Application.routes.draw do

  
  resources :searchonprojects

  root to: 'static_pages#home'

  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/profile', to: 'static_pages#profile'
  match '/create_org', to: 'static_pages#create_org'
  match '/browse_orgs', to: 'static_pages#browse_orgs'
  match '/list_orgs', to: 'static_pages#list_orgs'
  match '/org_profile', to: 'static_pages#org_profile'

  match '/create_job', to: 'static_pages#create_job'
  match '/browse_jobs', to: 'static_pages#browse_jobs'
  match '/list_jobs', to: 'static_pages#list_jobs'
  match '/single_job', to: 'static_pages#single_job'
  match '/single_project', to: 'static_pages#single_project'
  # match '/organizations', to: 'organizations#index'

  resources :jobs
  resources :organizations
  resources :jobenrollments, only: [:create, :destroy]
  resources :projects
  resources :projectenrollments, only: [:create, :destroy]

  resources :users do
    member do
      get :jobs, :projects
    end
  end

  resources :sessions, only: [:new, :create, :destroy]


  match '/signup',  to: 'users#new'
  match '/signin',  to: 'sessions#new'
  match '/signout', to: 'sessions#destroy', via: :delete
  
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
  
  # line below removed by justin!
  # root :to => 'organizations#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
