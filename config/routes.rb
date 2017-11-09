Rails.application.routes.draw do
  get "/admin/dashboard", to: "dashboards#index"
end
