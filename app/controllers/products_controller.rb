class ProductsController < ApplicationController

  def index
    @category_options = Category.all.map{|c| [c.name, c.id]}
    @category = Category.first
    @products = Product.where(category_id: @category.id )
  end
end