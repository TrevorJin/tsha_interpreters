Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get    'help'                 => 'static_pages#help'
  get    'about'                => 'static_pages#about'
  get    'interpreter_signup'   => 'users#new'
  get    'customer_signup'      => 'customers#new'
  get    'dashboard'            => 'users#dashboard'
  get    'pending_interpreters' => 'users#pending_users'
  get    'pending_customers'    => 'customers#pending_customers'
  get    'interpreters'         => 'users#index'
  get    'interpreters/new'     => 'users#new'
  get    'login'                => 'sessions#new'
  post   'login'                => 'sessions#create'
  delete 'logout'               => 'sessions#destroy'
  get    'customer_login'       => 'customer_sessions#new'
  post   'customer_login'       => 'customer_sessions#create'
  delete 'customer_logout'      => 'customer_sessions#destroy'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products
  resources :users do
    member do
      get 'promote_to_manager'
      get 'promote_to_admin'
      get 'demote_to_manager'
      get 'demote_to_interpreter'
      get 'approve_account'
      get 'deactivate_user'
    end
  end

  resources :customers do
    member do
      get 'approve_account'
      get 'deactivate_customer'
    end
  end

  resources :jobs
  resources :account_activations,      only: [:edit]
  resources :password_resets,          only: [:new, :create, :edit, :update]
  resources :customer_account_activations,      only: [:edit]
  resources :customer_password_resets, only: [:new, :create, :edit, :update]

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
