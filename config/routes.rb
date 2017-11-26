Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect('/admin')

  namespace :admin do
    get '/' => 'dashboard#home'
    get '/dashboard' => 'dashboard#index'
    resources :categories
    resources :products
    resources :orders
    resources :users
    resources :addresses
  end

end
