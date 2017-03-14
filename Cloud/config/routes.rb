Rails.application.routes.draw do
  root to: 'visitors#index'

  get 'health_check' => 'health_check#index'
  get '/privacy' => 'pages#privacy'
  get '/terms' => 'pages#terms'
  get '/help' => 'pages#help'

  resources :contacts, only: [:new, :create]

  devise_for :users, controllers: {
    :confirmations => 'confirmations',
    :sessions => 'sessions',
    :passwords => 'passwords'
  }


  as :user do
      patch '/user/confirmation' => 'confirmations#update', :via => :patch, :as => :update_user_confirmation
  end

  resources :users do
    collection do
      get 'unsubscribe'
    end
    member do
      post 'reset_password'
      post 'send_confirmation'
    end
    resources :notify_events, only: :index
  end

  resources :accounts, shallow: true do
    resources :users, only: [:index, :new, :create], controller: 'account_users'
    resources :units do
      resources :users, only: [:index, :new, :create], controller: 'unit_users'

      resource :network, only: :show

      resources :hubs, except: :show do
        member do
          get 'status'
          post 'restart'
        end
      end

      resources :sensors, except: :show do
        resources :readings, only: :index, controller: 'sensor_readings'
      end

      resources :line_check_lists
      resources :line_checks, only: [:show]
      resource :report, only: [:new, :create]
      resources :coolers
      resources :orders, only: [:index, :destroy] do
        resource :shipping_label, only: [:create]
        member do
          get :track
        end
      end
    end
  end
  resources :account_confirmation
  resources :orders do
    resources :fulfillment
    collection do
      get :open
    end
  end

  resources :admins, only: [:index, :new, :create, :update, :destroy]
  resources :account_users, only: [:update]
  resources :unit_users, only: [:update]

  #API
  namespace :api do
    namespace :v6, defaults: { format: :json } do
      resources :readings, only: :create
      resource :hub, only: :update
    end

    namespace :mv2 do
      jsonapi_resource :user
      jsonapi_resources :users
      jsonapi_resources :admins
      jsonapi_resources :account_users
      jsonapi_resources :unit_users
      jsonapi_resources :accounts
      jsonapi_resources :units
      jsonapi_resources :coolers
      jsonapi_resources :sensor_readings
      jsonapi_resources :line_checks
      jsonapi_resources :line_check_lists
      jsonapi_resources :line_check_items
      jsonapi_resources :line_check_readings

      resources :units, only: [] do
        member do
          get :chart
        end
      end

      resources :coolers, only: [] do
        member do
          get :chart
        end
      end
    end
  end

  scope :api do
    scope :mv2 do
      use_doorkeeper
    end
  end

  # Deprecated API
  match '/api/v1/*', to: 'errors#deprecated', via: :all
  match '/api/v2/*', to: 'errors#deprecated', via: :all
  match '/api/v3/*', to: 'errors#deprecated', via: :all
  match '/api/v4/*', to: 'errors#deprecated', via: :all
  match '/api/v5/*', to: 'errors#deprecated', via: :all
  match '/api/mv1/*', to: 'errors#deprecated', via: :all
  match '/api/sf1/*', to: 'errors#deprecated', via: :all
end
