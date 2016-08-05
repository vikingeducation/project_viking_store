Rails.application.routes.draw do
  root to: "dashboards#index"
  resources :categories
  resources :products

end
