Rails.application.routes.draw do
  root 'home#root'
  get '/date/:date' => 'home#index', as: 'index'
  post '/date/:date/create_todo/:id', to: 'shortcuts#create_todo', as: 'shortcut_create_todo'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users do
    resource :password, only: [ :show, :edit, :update ]
    post '/delete_image', to: 'users#delete_image', as: 'delete_image'
  end
  resources :todos do
    post '/toggle_status', to: 'todos#toggle_status', as: 'toggle_status'
    post '/create_shortcut', to: 'todos#create_shortcut', as: 'create_shortcut'
  end
  resources :shortcuts
  namespace :api, { format: 'json' } do
    resources :shortcuts, only: [ :index, :create, :update, :destroy ]
  end
  resources :routines
  get 'history/:month', to: 'routines#history', as: 'history'
  resources :password_resets, only: [ :new, :create, :edit, :update ]
end
