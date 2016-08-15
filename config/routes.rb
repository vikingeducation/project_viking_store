Rails.application.routes.draw do
  root 'dash#index'
  get '/admin' => 'admin#portal'
  resources :categories
  resources :products
  resources :users
  resources :orders
  resources :addresses
end
