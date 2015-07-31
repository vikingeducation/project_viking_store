Rails.application.routes.draw do

  root to: "admin#portal"

  get "admin/dashboard" => "analytics#dashboard"

  get "/admin" => "admin#portal"
  get 'admin/order_contents/remove_oc' => "order_contents#remove_oc"
  post 'admin/order_contents/update_everything' => "order_contents#update_everything"
  post 'admin/order_contents/create_oc' => "order_contents#create_oc"

  namespace :admin do
    resources :categories
    resources :products
    resources :users
    resources :addresses
    resources :orders
  end
end
