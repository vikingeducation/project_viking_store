class ProductsController < ApplicationController

  layout "admin_portal"

  def edit
    @product = Product.find(params[:id])
  end

  def index
    @column_names = ["id", 'name','price','category',"show","edit","delete"]
    @products = Product.all_in_arrays
  end

  def show
    @product = Product.find(params[:id])
    @category_name = Product.category_name(@product.category_id)
    @times_ordered = Product.times_ordered(params[:id])
    @number_of_carts_in = Product.number_of_carts_in(params[:id]).first.total
  end

end
