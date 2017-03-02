Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/dashboard', to: 'dashboard#index'
  get '/admin', to: 'dashboard#admin'

  namespace :admin do
    resources :categories
    resources :products
    resources :users do
      resources :addresses, only: [:index, :new]
      resources :orders, only: [:show, :new]
      resources :credit_cards, only: :destroy
    end
  end


end
