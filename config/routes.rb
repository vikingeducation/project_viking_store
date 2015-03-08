Rails.application.routes.draw do

  root 'admins#index'

  resources :dashboards, only: [:index]
  resources :admins, only: [:index]
  resources :categories
  resources :products
  resources :users do
    resources :credit_cards, only: [:destroy]
    resources :orders, shallow: true
    resources :addresses, shallow: true
  end

end
