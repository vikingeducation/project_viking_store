Rails.application.routes.draw do
  # root 'home#index'
  root 'home#dashboard'

  get 'dashboard' => 'home#dashboard'
end
