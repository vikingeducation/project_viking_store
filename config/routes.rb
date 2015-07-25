Rails.application.routes.draw do
  root to: 'dashboard#index'
    
  get 'dashboard/admin' => 'dashboard#admin'
  resources :dashboard, only: :index
  
end
