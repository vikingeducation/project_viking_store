Rails.application.routes.draw do
  get 'categories/new'

  namespace :admin do
    get '/' => 'categories#index'
    resources :categories
    resources :products
    resources :users
    resources :addresses
    resources :orders
  end

  root 'products#index'

  resources :products
  resources :users, except: [:index]
  resource :cart, only: [:show]
  resources :orders
  resources :categories
  resource :session, only: [:new,:create,:destroy]

  get '/dashboard' => 'dashboard#index'
  get '/dashboard/orders_by_day' => 'dashboard#orders_by_day'
  get '/dashboard/orders_by_week' => 'dashboard#orders_by_week'
end
