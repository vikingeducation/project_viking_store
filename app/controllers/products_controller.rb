class ProductsController < ApplicationController
  def index
    @products = Product.all
    render layout: "admin"
  end
end
