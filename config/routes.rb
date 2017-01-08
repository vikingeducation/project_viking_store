Rails.application.routes.draw do

  root :to => "dashboards#index"

  get "/index" => "dashboards#index"

  
end
