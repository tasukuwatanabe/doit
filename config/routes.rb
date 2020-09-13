Rails.application.routes.draw do
  root 'top#dashboard'
  get ':date' => 'tasks#index', as: 'index'
  resources :tasks, except: [ :index ]
end
