Rails.application.routes.draw do
  root 'analytics#index'
  get "analytics" => "analytics#index"
  resources :analytics
end
