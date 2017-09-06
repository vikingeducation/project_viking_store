Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'orders#index'

  get '/dashboard', to: 'dashboard#home'

  resources :categories,
            :products,
            :orders

  resources :users do
    resources :addresses
  end

  get 'addresses/all', to: 'addresses#all'
end
