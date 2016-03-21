class ProductsController < ApplicationController

  layout "admin_portal"

  def index
    @column_names = ["id", 'name','price','category_id',"show","edit","delete"]
    @products = Product.all_in_arrays
  end

  def show
    @product = Product.find(params[:id])
  end

end
