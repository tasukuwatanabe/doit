Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'oauth#create'
  delete '/cancel_oauth/:provider', to: 'oauth#destroy'

  namespace :api, format: 'json' do
    namespace :v1 do
      resources :todos, only: %i[index create update destroy] do
        put '/toggle_status', to: 'todos#toggle_status'
      end
      get '/search', to: 'todos#search'
      resources :shortcuts, only: %i[index create update destroy]
      resources :labels, only: %i[index create update destroy]
      get '/current_user', to: 'users#current_user'
      resources :users, only: %i[create update destroy] do
        resource :password, only: %i[update]
      end
      post '/login', to: 'sessions#create'
      delete '/logout', to: 'sessions#destroy'
      resources :password_resets, only: %i[create update]
      resources :account_activations, only: :edit
      resources :email_confirmations, only: %i[edit destroy]

      get :health_check, to: 'health_check#index'
    end
  end
end
