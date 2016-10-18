Rails.application.routes.draw do
  get 'categories/index'
  get 'admin' => 'admin#index'
  get 'dashboard' => 'dashboard#main'

  root 'dashboard#main'

  resources :admin
end
