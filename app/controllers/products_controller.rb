class ProductsController < ApplicationController

  def index
    @products = Product.all.limit(6)
  end


end
