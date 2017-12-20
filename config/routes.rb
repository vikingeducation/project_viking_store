Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: redirect('/admin')

  namespace :admin do
    get '/', to: 'dashboard#home'
    get '/dashboard', to: 'dashboard#index'
    resources :categories
    resources :products
    resources :orders do
      resources :order_contents, only: [:update, :create] do
        collection do
          get :edit
          post :update_multiple, action: "update_multiple"
          post :create_multiple, action: "create_multiple"
        end
      end
    end
    resources :users do
      resources :addresses, only: [:index, :new]
      resources :orders, only: [:index, :new]
    end
    resources :addresses
  end

end
