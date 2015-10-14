Rails.application.routes.draw do

  root 'categories#index'

  get 'dashboard' => 'dashboard#index'

  resources :categories
  resources :products

end
