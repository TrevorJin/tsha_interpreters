Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'customer_password_resets/new'
  get 'customer_password_resets/edit'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  root 'static_pages#home'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get    'help'                  => 'static_pages#help'
  get    'about'                 => 'static_pages#about'
  get    'interpreter_signup'    => 'users#new'
  get    'customer_signup'       => 'customers#new'
  get    'dashboard'             => 'users#dashboard'
  get    'pending_interpreters'  => 'users#pending_users'
  get    'pending_customers'     => 'customers#pending_customers'
  get    'interpreters'          => 'users#index'
  get    'interpreters/new'      => 'users#new'
  get    'login'                 => 'sessions#new'
  post   'login'                 => 'sessions#create'
  delete 'logout'                => 'sessions#destroy'
  get    'customer_login'        => 'customer_sessions#new'
  post   'customer_login'        => 'customer_sessions#create'
  delete 'customer_logout'       => 'customer_sessions#destroy'
  get    'current_jobs'          => 'users#current_jobs'
  get    'pending_jobs'          => 'users#pending_jobs'
  get    'completed_jobs'        => 'users#completed_jobs'
  get    'rejected_jobs'         => 'users#rejected_jobs'
  get    'pending_approval'      => 'customers#pending_approval'
  get    'approved_job_requests' => 'customers#approved_job_requests'
  get    'rejected_job_requests' => 'customers#rejected_job_requests'
  get    'expired_job_requests'  => 'customers#expired_job_requests'

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
      get 'promote_qualification'
      get 'revoke_qualification'
      get :confirmed_jobs, :attempted_jobs
      get 'approve_job_request'
      get 'reject_job_request'
    end
  end

  resources :customers do
    member do
      get 'approve_account'
      get 'deactivate_customer'
    end
  end

  resources :jobs do
    member do
      get 'new_job_from_job_request'
    end
  end
  resources :job_requests
  resources :account_activations,           only: [:edit]
  resources :password_resets,               only: [:new, :create, :edit, :update]
  resources :customer_account_activations,  only: [:edit]
  resources :customer_password_resets,      only: [:new, :create, :edit, :update]
  resources :appointments,                  only: [:create, :destroy]
  resources :interpreting_requests,         only: [:create, :destroy]
  resources :job_completions,               only: [:create, :destroy]
  resources :job_rejection,                 only: [:create, :destroy]


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
