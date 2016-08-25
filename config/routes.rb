Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'dashboards#index'
  get 'dashboard', to: 'dashboards#index'
  resources :categories
  resources :products
  resources :users do
    resources :addresses
    resources :orders
    resources :credit_cards
  end

end
