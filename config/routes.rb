Rails.application.routes.draw do
  # root 'home#index'
  root 'home#dashboard'

  get 'dashboard' => 'home#dashboard'

  namespace :admin do
    resources :categories
  end
end
