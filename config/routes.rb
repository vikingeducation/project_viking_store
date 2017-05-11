Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "category#index"

  namespace :admin do
    resources :category
  end
  get "/dashboard" => "dashboard#index"
end
