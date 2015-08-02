Rails.application.routes.draw do

  root to: "store#home"

  get '/home' => "store#home"

  get '/add_to_cart' => "store#add_to_cart"
  get "/admin" => "admin#portal"

  namespace :admin do
    resources :categories
    resources :products
    resources :users
    resources :addresses
    resources :orders

    get "dashboard" => "analytics#dashboard"
    get 'order_contents/remove_oc' => "order_contents#remove_oc"
    post 'order_contents/update_everything' => "order_contents#update_everything"
    post 'order_contents/create_oc' => "order_contents#create_oc"
  end

  resource :session, :only => [:new, :create, :destroy]
  resources :users, :except => [:index]
  resources :orders, :only => [:edit]
end
