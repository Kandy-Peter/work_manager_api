Rails.application.routes.draw do

  mount Rswag::Ui::Engine => '/'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      get '/search', to: 'users#search'

      resources :demo_requests

      resources :organizations do
        #****ASSISTANCES****
        resources :assistances
        resources :users do
          resources :assistances, only: [:index, :create]
        end

        #****DEPARTMENTS****
        resources :departments do
          resources :positions
        end

        #****SALARIES****
        resources :salaries do
          collection do
            get 'user_salaries', to: 'salaries#user_salaries'
          end
        end

        #****USER JOURNEY****
        get '/reports/:user_id/journeys', to: 'reports/journeys#show', as: 'journey_report'
      end

      #**** DEMO REQUESTS ****
      namespace :requests do
        resources :demo_requests do
          member do
            put 'update_demo_request_status', to: 'demo_requests#update_demo_request_status'
          end
        end
      end
    end
  end

  get 'users/index'
  scope :api do
    scope :v1 do
      devise_for :users,
                 path: 'auth',
                 path_names: {
                   sign_in: 'login',
                   sign_out: 'logout',
                   registration: 'signup'
                 },
                 controllers: {
                   registrations: 'api/v1/registrations',
                   sessions: 'api/v1/sessions',
                   password_resets: 'api/v1/password_resets'
                 }, defaults: { format: :json }
      devise_scope :user do
        get '/:organization_id/profile', to: 'api/v1/users#profile', as: :user_root
        get '/auth/users', to: 'api/v1/users#index', as: :users
        get '/auth/users/:id', to: 'api/v1/users#show', as: :user
        get '/users/show/:username', to: 'api/v1/users#show_by_username', as: :show_by_username
        put '/:organization_id/users/:id', to: 'api/v1/users#update', as: :update_user
        delete '/auth/users', to: 'api/v1/users#destroy', as: :destroy_user
        post 'password_resets', to: 'api/v1/password_resets#create'
        put 'password_resets/:token', to: 'api/v1/password_resets#update'
      end
    end
  end
end
