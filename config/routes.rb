Rails.application.routes.draw do
  root 'top#dashboard'
  get 'dates/:date' => 'tasks#index', as: 'index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: :index
  resources :tasks, except: :index
  resources :shortcuts
end
