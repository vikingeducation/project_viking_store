class ProductsController < ApplicationController

  def index
    @category = Category.first
    @products = Product.where(category_id: @category.id )
  end
end
