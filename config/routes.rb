Rails.application.routes.draw do
  namespace :admin do
    get "/dashboard", to: "dashboards#index"
  end
end
