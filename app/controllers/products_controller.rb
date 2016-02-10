class ProductsController < ApplicationController

  def index
    @category_options = Category.all.map{|c| [c.name, c.id]}
    @product_filter = params[:product_filter]
    @products = @product_filter ? Product.containing_category(@product_filter) : Product.all
  end

  def show
  end
end