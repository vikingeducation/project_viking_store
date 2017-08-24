Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'categories#index'

  get '/dashboard', to: 'dashboard#home'

  resources :categories

  resources :products, only: [:index, :show, :new]
end
