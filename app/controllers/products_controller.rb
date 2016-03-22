class ProductsController < ApplicationController

  layout "admin_portal"

  def index
    @column_names = ["id", 'name','price','category',"show","edit","delete"]
    @products = Product.all_in_arrays
  end

  def show
    @product = Product.find(params[:id])
    @category_name = Product.category_name(@product.category_id)
  end

end
