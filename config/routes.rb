Rails.application.routes.draw do

  root 'products#index'

  resource :session, :only => [:new, :create, :destroy]
  resources :products, :only => [:index]
  
  resources :users, :only => [:new, :create, :edit, :update, :destroy] do
    resources :addresses, :only => [:new, :create, :edit, :update]
    resources :orders, :only => [:show, :create, :edit, :update]
    get 'orders/:id/checkout' => 'orders#checkout', as: :checkout
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
