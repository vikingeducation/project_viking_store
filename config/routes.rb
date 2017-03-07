Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/dashboard', to: 'dashboard#index'
  get '/admin', to: 'dashboard#admin'
  root 'admin/users#index'

  namespace :admin do
    resources :categories
    resources :products
    resources :users do
      resources :addresses, only: [:index, :new, :create, :edit, :show, :update, :destroy]
      resources :orders, only: [:show, :new, :create, :index]
      resources :credit_cards, only: :destroy
    end
    resources :addresses, only: :index
    resources :orders, only: [:edit, :index, :show, :destroy] do
      post 'update_contents', on: :member
      post 'add_products', on: :member
    end
    resources :order_contents, only: [:destroy]
  end


end
