Rails.application.routes.draw do

  root 'products#index'

  resources :sessions, :only => [:new, :create, :destroy]
  resources :products, :only => [:index]
  resources :orders, :only => [:create, :update]

  resources :users, :only => [:new, :create] do
    resources :addresses, :only => [:new, :create]
  end

  namespace :admin do
    get 'dashboard' => 'dashboard#index'
    resources :categories
    resources :products
    resources :users
    resources :credit_cards, :only => [:destroy]
    resources :addresses
    resources :orders
  end

end
