Rails.application.routes.draw do
  root 'top#dashboard'
  get 'dates/:date' => 'tasks#index', as: 'index'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users, except: :index do
    resource :password, only: [ :show, :edit, :update ]
  end
  resources :tasks, except: :index
  post '/tasks/:id/toggle_status', to: 'tasks#toggle_status', as: 'toggle_status'
  resources :shortcuts
  resources :routines
end
