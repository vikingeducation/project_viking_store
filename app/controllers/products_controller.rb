class ProductsController < ApplicationController

  def index
    @category = Category.all.sample
    @products = Product.where(:category_id == @category.id )
  end
end
