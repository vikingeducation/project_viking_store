Rails.application.routes.draw do

  root :to => "dashboards#admin"

  resources :categories

  resources :products

  get "/index" => "dashboards#index"

  get "/admin" => "dashboards#admin"

  
end
