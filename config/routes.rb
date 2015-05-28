Rails.application.routes.draw do
  root 'dashboard#index'
  resources :admin, only: [:index]
  resources :products
  resources :categories
end
