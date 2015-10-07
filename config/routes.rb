Rails.application.routes.draw do

  root 'dashboard#index'

  get 'dashboard' => 'dashboard#index'

  resources :categories

end
