Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  root 'products#index'
  resources :products, only: [:index]

  resources :users, except: [:index]

  resources :credit_cards, only: [:destroy]

  get 'shopping_cart', to: "orders#edit"
  post 'shopping_cart', to: "orders#create"
  patch 'shopping_cart', to: "orders#update"
  delete 'shopping_cart', to: "orders#destroy"
  post 'merge_shopping_cart', to: 'orders#merge_or_discard_cart'
  get 'checkout', to: "orders#checkout"
  post 'checkout', to: "orders#place_order"

  resource :session, only: [:new, :create, :destroy]
  post 'signin', to: "session#create"
  get 'signin', to: "session#new"
  delete 'signout', to: "session#destroy" 

  get '/dashboard' => 'dashboard#home'

  namespace :admin do
    root 'orders#index'
    resources :addresses, only: [:index, :create, :update]
    resources :users do
      resources :addresses
    end
    resources :credit_cards
    resources :categories
    resources :products
    resources :orders
  end

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
