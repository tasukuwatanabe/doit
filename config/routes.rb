Rails.application.routes.draw do
  root 'todos#index'
  get '/history', to: 'todos#history'
  namespace :api do
    resources :todos, except: %i[new edit show]
    resources :shortcuts, except: %i[new edit show]
    resources :labels, except: %i[new edit show]
    get '/current_user', to: 'users#current_user'
    resources :users do
      resource :password, only: %i[edit update]
    end
  end
  # get '/date/:date', to: 'todos#index', as: 'todo_index'
  # get '/search', to: 'todos#search', as: 'search'
  post '/date/:date/create_todo/:id', to: 'shortcuts#create_todo', as: 'shortcut_create_todo'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/auth/failure', to: 'users#auth_failure', as: :auth_failure
  get '/auth/:provider/callback', to: 'sessions#create'
  post '/guest_login', to: 'sessions#guest_login'
  delete '/logout', to: 'sessions#destroy'
  delete '/cancel_oauth/:uid_type', to: 'users#cancel_oauth', as: 'cancel_oauth'
  resources :password_resets, only: %i[new create edit update]
  resources :account_activations, only: [:edit]
  resources :email_confirmations, only: %i[edit destroy]
end
