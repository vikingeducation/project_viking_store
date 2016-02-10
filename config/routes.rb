Rails.application.routes.draw do

  resources :products, only: [:index, :show]
  resource :session, only: [:new, :create, :destroy]
  resources :users
  resources :orders
  resources :carts
  root 'products#index'

  namespace :admin do
    root 'dashboard#index'
    resources :categories
    resources :products
    resources :addresses, only: [:index]
    resources :orders, only: [:index]
    resources :purchases, only: [:create, :update, :destroy]
    resources :users do
      resources :addresses
      resources :orders
      resources :credit_cards, only: [:destroy]
    end
  end
end
