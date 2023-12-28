Rails.application.routes.draw do
  namespace :api, format: 'json' do
    namespace :v1 do
      resources :todos, only: %i[index create update destroy] do
        put '/toggle_status', to: 'todos#toggle_status'
      end
      resources :shortcuts, only: %i[index create update destroy]
      resources :labels, only: %i[index create update destroy]
      resources :users, only: %i[create update destroy] do
        collection do
          get :current, to: 'users#current'
        end
        resource :password, only: %i[update]
      end
      post '/login', to: 'sessions#create'
      post '/guest', to: 'sessions#guest'
      delete '/logout', to: 'sessions#destroy'
      resources :password_resets, only: %i[create update]
      resources :account_activations, only: :edit
      resources :email_confirmations, only: %i[edit destroy]
      get :health_check, to: 'health_check#index'
    end
  end
end
