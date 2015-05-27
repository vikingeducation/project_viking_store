Rails.application.routes.draw do
  root 'dashboard#index'
  resources :admin, only: [:index]
end
