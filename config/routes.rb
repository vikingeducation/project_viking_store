Rails.application.routes.draw do

  root 'admin#dashboard'

  get 'admin/dashboard', to: 'admin#dashboard', as: 'dashboard'
  namespace :admin do
    resources :users
    resources :addresses, only: [:index]
    resources :orders, only: [:index]
    resources :products
    resources :categories
  end

  # resources :users
  # resources :addresses, only: [:index]
  # resources :orders, only: [:index]
  # resources :products
  # resources :categories

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
