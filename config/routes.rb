Rails.application.routes.draw do
  root 'products#index'
  resources :orders
  resources :carts
  resources :sessions, only: [:new, :create, :destroy]

  namespace :admin do
    root 'dashboard#index'
    resources :admin, only: [:index]
    resources :products
    resources :categories
    resources :users
    resources :credit_cards
    resources :addresses
    resources :orders
    resources :order_contents
  end
end
