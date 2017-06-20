Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :dashboard
  # root 'dashboard#index'
  root 'dashboard#basic_admin_template'
end


