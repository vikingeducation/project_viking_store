Rails.application.routes.draw do
  namespace :admin do
    get "/dashboard", to: "dashboards#index"
    resources :categories
  end
end
