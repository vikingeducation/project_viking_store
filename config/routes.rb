Rails.application.routes.draw do

  root :to => "dashboards#admin"

  resources :categories

  get "/index" => "dashboards#index"

  get "/admin" => "dashboards#admin"

  
end
