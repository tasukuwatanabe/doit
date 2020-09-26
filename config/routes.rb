Rails.application.routes.draw do
  root 'top#dashboard'
  get '/dates/:date' => 'todos#index', as: 'index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: :index do
    resource :password, only: [ :show, :edit, :update ]
  end
  resources :todos, except: :index do
    post '/toggle_status', to: 'todos#toggle_status', as: 'toggle_status'
  end
  resources :shortcuts
  post '/create_todo', to: 'shortcuts#create_todo', as: 'shortcut_create_todo'
  resources :routines, only: [ :create, :update ]
end
