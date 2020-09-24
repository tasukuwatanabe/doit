Rails.application.routes.draw do
  root 'top#dashboard'
  get 'dates/:date' => 'todos#index', as: 'index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: :index
  resources :todos, except: :index
  post '/todos/:id/toggle_status', to: 'todos#toggle_status', as: 'toggle_status'
  resources :shortcuts
  resources :routines
end
