Rails.application.routes.draw do
  namespace :admin do
    get "/dashboard", to: "dashboards#index"
    resources :categories
    resources :products
  end
end
