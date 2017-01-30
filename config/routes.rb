Rails.application.routes.draw do
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	root "categories#index"
  	get "/dashboard" => "dashboard#index"
  	resources :users
  	resources :categories
  	resources :addresses
  	resources :products
  	resources :orders
end
