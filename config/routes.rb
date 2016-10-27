Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#home'

  get 'dashboard' => 'dashboard#index'
  get 'admin' => 'admin#index'

  resources :categories
  resources :products
  resources :users
  resources :addresses
  
end
