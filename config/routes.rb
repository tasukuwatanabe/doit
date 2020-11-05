Rails.application.routes.draw do
  root 'todos#index'
  get '/history', to: 'todos#index'
  get '/shortcuts', to: 'todos#index'
  get '/labels', to: 'todos#index'
  get '/user/:id/edit', to: 'todos#index'
  get '/password/:id/edit', to: 'todos#index'
  get '/signup', to: 'todos#index'
  get '/login', to: 'todos#index'
  get '/auth/failure', to: 'todos#index'
  get '/auth/:provider/callback', to: 'todos#index'
  namespace :api do
    resources :todos, except: %i[new edit show] do
      put '/toggle_status', to: 'todos#toggle_status'
    end
    resources :shortcuts, except: %i[new edit show]
    resources :labels, except: %i[new edit show]
    get '/current_user', to: 'users#current_user'
    resources :users, only: %i[edit update destroy] do
      resource :password, only: %i[edit update]
    end
    get '/signup', to: 'users#new'
    get '/login', to: 'sessions#new'
    post '/login', to: 'sessions#create'
    get '/auth/failure', to: 'users#auth_failure', as: :auth_failure
    get '/auth/:provider/callback', to: 'sessions#create'
    post '/guest_login', to: 'sessions#guest_login'
    delete '/logout', to: 'sessions#destroy'
    delete '/cancel_oauth/:uid_type', to: 'users#cancel_oauth', as: 'cancel_oauth'
  end

  # get '/search', to: 'todos#search', as: 'search'
  resources :password_resets, only: %i[new create edit update]
  resources :account_activations, only: [:edit]
  resources :email_confirmations, only: %i[edit destroy]
end
