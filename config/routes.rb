Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
  get 'dashboard', to: 'dashboards#index'
  resources :addresses
  resources :categories
  resources :products
  resources :users do
    resources :user_addresses
    resources :user_orders
    resources :user_credit_cards
  end

end
