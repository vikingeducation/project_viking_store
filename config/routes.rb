Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'users#index'

  resources :categories,
            :products,
            :orders

  resources :users do
    resources :addresses
  end

  resources :credit_cards, only: [:destroy]
  resources :order_contents, only: [:create, :destroy]

  post 'order_contents/update_order', to: 'order_contents#update_order'

  get 'addresses/all', to: 'addresses#all'
  get '/dashboard', to: 'dashboard#home'
end
