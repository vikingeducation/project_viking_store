Rails.application.routes.draw do

  root 'categories#index'

  get 'dashboard' => 'dashboard#index'

  resources :categories
  resources :products
  resources :users
  resources :credit_cards, :only => [:destroy]
  resources :addresses
  resources :orders

end
