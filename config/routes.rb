Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
  resources :main
  resources :addresses
  resources :categories
  resources :application_records
  resources :cities
  resources :credit_cards
  resources :orders
  resources :order_content
  resources :products
  resources :states
  resources :users
end
