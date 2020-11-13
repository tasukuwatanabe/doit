Rails.application.routes.draw do
  root 'home#index'
  get '/shortcuts', to: 'home#index'
  get '/labels', to: 'home#index'
  get '/user/:id/edit', to: 'home#index'
  get '/password/:id/edit', to: 'home#index'
  get '/signup', to: 'home#index'
  get '/login', to: 'home#index'
  get '/auth/failure', to: 'home#index'
  get '/auth/:provider/callback', to: 'oauth#create'
  delete '/cancel_oauth/:uid_type', to: 'oauth#cancel_oauth', as: 'cancel_oauth'

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
    post '/login', to: 'sessions#create'
    post '/guest_login', to: 'sessions#guest_login'
    delete '/logout', to: 'sessions#destroy'
  end

  # get '/search', to: 'todos#search', as: 'search'
  resources :password_resets, only: %i[new create edit update]
  resources :account_activations, only: [:edit]
  resources :email_confirmations, only: %i[edit destroy]
end
