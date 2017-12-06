Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect('/admin')

  namespace :admin do
    get '/', to: 'dashboard#home'
    get '/dashboard', to: 'dashboard#index'
    resources :categories
    resources :products
    resources :orders
    resources :users do
      resources :addresses, only: [:index, :new]
      resources :orders, only: [:index, :new]
    end
    resources :addresses
  end

end
