Rails.application.routes.draw do

  get 'dashboard' => 'dashboard#main'

  root 'admin#index'

  resources :admin
  resources :categories
  resources :products
  resources :users do
    resources :addresses
    resources :orders
  end
end
