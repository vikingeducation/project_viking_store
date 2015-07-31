Rails.application.routes.draw do

  root to: "admin#portal"

  get "admin/dashboard" => "admin/analytics#dashboard"

  get "/admin" => "admin#portal"
  get 'admin/order_contents/remove_oc' => "admin/order_contents#remove_oc"
  post 'admin/order_contents/update_everything' => "admin/order_contents#update_everything"
  post 'admin/order_contents/create_oc' => "admin/order_contents#create_oc"

  get '/home' => "store#home"
  #resources :store

  namespace :admin do
    resources :categories
    resources :products
    resources :users
    resources :addresses
    resources :orders
  end
end
