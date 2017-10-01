Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'
  resources :main, only: [:index]
  resources :addresses, only: [:index]
  resources :orders, only: [:index]
  resources :categories, :users, :products
  resources :credit_cards, only: [:destroy]
  resources :users do
      resources :addresses
      resources :orders
    end

end
