Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "admin#index"

  resources :admin
  get "/dashboard" => "dashboard#index"
end
