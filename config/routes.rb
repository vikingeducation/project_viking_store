Rails.application.routes.draw do
  get "/dashboard" => "dashboard#index"
  get "/admin_portal" => 'categories#index_categ'
  get "/admin_portal/new_categ" => 'categories#new_categ'
  post "/admin_portal/create_categ" => 'categories#create_categ'
  get "/admin_portal/show_categ" => 'categories#show_categ'
end
