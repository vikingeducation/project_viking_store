Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "admin/products#index"

  namespace :admin do
    resources :addresses
    resources :categories
    resources :orders
    resources :products
    resources :users
  end
  get "/dashboard" => "dashboard#index"
end
