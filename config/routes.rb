Rails.application.routes.draw do
  root 'tops#home'
  get '/date/:date' => 'tops#index', as: 'index'
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
  resources :routines
  get 'history', to: 'routines#history'
  resources :password_resets, only: [ :new, :create, :edit, :update ]
end
