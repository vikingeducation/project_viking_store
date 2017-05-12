class Admin::ProductsController < ApplicationController
  layout "admin"
  
  def index
    @products = Product.get_with_category
  end

end
