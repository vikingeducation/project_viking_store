class ProductsController < ApplicationController

  def index
    @products = Product.all.order(:name)    
  end

end
