Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "admin/categories#index"

  namespace :admin do
    resources :categories
  end
  get "/dashboard" => "dashboard#index"
end
