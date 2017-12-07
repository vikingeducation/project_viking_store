Rails.application.routes.draw do

  get 'pages/admin', to: 'pages#admin', as: 'admin'
  get 'pages/dashboard', to: 'pages#dashboard', as: 'dashboard'
  resources :pages, only: [:admin, :dashboard]
  resources :users
  resources :addresses, only: [:index]
  resources :orders, only: [:index]
  resources :products
  resources :categories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
