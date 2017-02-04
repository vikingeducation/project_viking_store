Rails.application.routes.draw do
  	# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  	root "categories#index"
  	get "/dashboard" => "dashboard#index"
  	resources :users do
  		resources :addresses
  		resources :orders
  		resources :credit_cards
	end
  	resources :categories
  	resources :addresses
  	resources :products
  	resources :orders
    resources :order_contents
end
