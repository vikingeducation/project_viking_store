Rails.application.routes.draw do
  root to: 'dashboard#index'

  get '/admin' => 'admin#index'
  resources :dashboard, only: :index
  resources :categories
end
