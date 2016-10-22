Rails.application.routes.draw do

  root 'admin/users#index'

  namespace :admin do
    resources :dashboard
    resources :categories
    resources :products
    resources :addresses, only: [:index]
    resources :orders, only: [:index]
    resources :users do
      resources :addresses
      resources :orders
    end
    resources :order_contents
  end
end
