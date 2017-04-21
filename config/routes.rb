Rails.application.routes.draw do
  get "/dashboard" => "dashboard#index"
  get "/admin_portal" => 'categories#index_categ'
end
