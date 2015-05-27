Rails.application.routes.draw do
  # API
  mount API::API => '/api'

  # help
  get 'help' => 'help#index'
  get 'help/:category/:file'  => 'help#show', as: :help_page

  # root path
  authenticated :user do
    root to: "ideas#index" #, as: :authenticated_root
  end
  unauthenticated do
    root to: "home#index", as: :unauthenticated_root
  end

  devise_for :users, controllers: { passwords: "ideaegg_api/passwords" }
  devise_scope :user do
    get     "/sign_in"    => "devise/sessions#new"
    delete  "/sign_out"   => "devise/sessions#destroy"
    get     "/register" => "devise/registrations#new"
  end

  concern :commentable do
    resources :comments, only: [:create]
  end

  resources :ideas, concerns: [:commentable]
  resources :users, only: [:show, :edit, :update]
  post   'follow'   => 'users#follow'
  post   'unfollow'   => 'users#unfollow'
  post   'like'   => 'ideas#like'
  post   'unlike'   => 'ideas#unlike'

  get '/uploads/uptoken' => 'uploads#uptoken'

  namespace :ideaegg_api, path: :api, as: :api, defaults: { format: :json } do
    scope :v2 do
      post    'sign_up' => 'users#create'
      post    'sign_in' => 'sessions#create'
      get     'sign_up_temporarily' => 'users#sign_up_temporarily'
      post    'sign_in_with/:provider' => 'sessions#create_by_provider'

      put     'ideas/:id/vote' => 'ideas#vote'
      delete  'ideas/:id/vote' => 'ideas#unvote'
      put     'ideas/:id/star' => 'ideas#star'
      delete  'ideas/:id/star' => 'ideas#unstar'

      post    'markdown/preview' => 'markdown#preview'

      resource :user, controller: :user, only: [:show, :update] do
        put 'password' => 'user#update_password'

        resources :ideas, only: [] do
          collection do
            get :voted
            get :starred
            get :created
          end
        end
      end

      resources :ideas, only: [:create, :show, :index]
      devise_scope :user do
        post 'reset_password' => 'passwords#create'
      end
    end
  end
end
