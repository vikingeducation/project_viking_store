class ProductsController < ApplicationController
  layout "shop"

  def index
    @products = Product.all
  end
end
