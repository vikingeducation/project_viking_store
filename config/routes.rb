Rails.application.routes.draw do

  resources :dashboards, only: [:index]

  root 'dashboards#index'
  get '/dashboard' => 'dashboards#index'
  get '/admin' => 'users#index'
  # namespace :admin do
    # root 'users#index'
  resources :users
  # end
  #############

  # start admin portal
  # create controller for users delete admins

  # namespace :admin do
  #   root 'users#index'   
  #   resources :categories     #   ? resource  resources ?
  #   resources :products
  #   resources :users
  #   resources :addresses
  #   resources :orders
  # end

  # refactor and complete view
  # navbar goes in admin layout
  # db code goes in models/user

  # add resource for category
  # create controller for category
  # write view/model, model code goes in model/category

  # etc., etc. for other resources

  ####################


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
