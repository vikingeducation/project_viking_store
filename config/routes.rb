Rails.application.routes.draw do

  root 'products#index'

  resources :session, :only => [:new, :create, :destroy]
  resources :products, :only => [:index]
  resources :orders, :only => [:create, :update]

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
