Rails.application.routes.draw do
  root 'top#dashboard'
  get 'dates/:date' => 'tasks#index', as: 'index'
  resources :tasks, except: [ :index ]
  resources :users, except: [ :index ]
  get 'users' => 'users#index'
end
