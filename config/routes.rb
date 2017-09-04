Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'addresses#index'

  get '/dashboard', to: 'dashboard#home'

  resources :categories,
            :products

  resources :users do
    resources :addresses
  end

  resources :addresses, only: [] do
    collection do
      get 'all'
    end
  end
end
