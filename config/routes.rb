Rails.application.routes.draw do

  root 'admins#index'

  resources :dashboards, only: [:index]
  resources :admins, only: [:index]
  resources :categories

end
