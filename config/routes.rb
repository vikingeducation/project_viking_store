Rails.application.routes.draw do

  root 'admin#dashboard'

  get 'admin/dashboard', to: 'admin#dashboard', as: 'dashboard'
  namespace :admin do
    resources :addresses, only: [:index]
    resources :users do
      resources :addresses
      resources :orders
    end
    resources :orders, only: [:show, :edit, :index] do
      resources :order_contents, only: [:create, :destroy]
    end
    post 'order_contents/update' => 'order_contents#update'
    resources :products
    resources :categories
    resources :credit_cards, only: [:destroy]
  end

  resources :users do
    resources :credit_cards, only: [:new, :create, :destroy]
  end

  # resources :users
  # resources :addresses, only: [:index]
  # resources :orders, only: [:index]
  # resources :products
  # resources :categories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
