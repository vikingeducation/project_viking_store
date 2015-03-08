Rails.application.routes.draw do

  root 'admins#index'

  resources :dashboards, only: [:index]
  resources :admins, only: [:index]
  resources :categories
  resources :products
  resources :users do
    resources :credit_cards, only: [:destroy]
    resources :orders, only: [:new, :create, :show]
  end

end
