Rails.application.routes.draw do

  get 'admin' => 'admin#index'
  get 'dashboard' => 'dashboard#main'

  root 'admin#index'

  resources :admin
  resources :categories
  resources :products
end
