Rails.application.routes.draw do

    get "/dashboard" => "dashboard#index"
  # get "/admin_portal" => 'categories#index_categ'
  # get "/admin_portal/new_categ" => 'categories#new_categ'
  # post "/admin_portal/create_categ" => 'categories#create_categ'
  # get "/admin_portal/:id" => 'categories#show_categ'
  # get "/admin_portal/:id/edit_categ" => 'categories#edit_categ'
  # patch "/admin_portal/:id" => 'categories#update_categ'
  # put "/admin_portal/:id" => 'categories#update_categ'
  # delete "/admin_portal/:id" => 'categories#delete_categ'


  namespace :admin do
    resources :categories
    resources :products
    resources :users
    resources :addresses
  end

end
