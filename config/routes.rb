Rails.application.routes.draw do

  root :to => "dashboards#index"

  resources :categories

  resources :products

  resources :users

  resources :addresses

  get "/index" => "dashboards#index"

  get "/admin" => "dashboards#admin"

  
end
