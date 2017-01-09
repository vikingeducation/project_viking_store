Rails.application.routes.draw do

  root :to => "dashboards#admin"

  get "/index" => "dashboards#index"

  get "/admin" => "dashboards#admin"

  
end
