class ProductsController < ApplicationController

  def index
    @products = Product.all_with_category
  end

end
