Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'dashboard#home'

  get '/dashboard', to: 'dashboard#home', as: :home
end
