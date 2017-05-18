Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "admin/products#index"

  namespace :admin do
    resources :addresses
    resources :categories
    resources :orders
    put "/orders/:id/update_order_contents" => "orders#update_order_contents"
    post "/orders/:id/create_order_contents" => "orders#create_order_contents"
    resources :order_contents
    resources :products
    resources :users
  end
  get "/dashboard" => "dashboard#index"
end
