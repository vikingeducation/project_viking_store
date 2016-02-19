class ProductsController < ApplicationController

  def index
    
    session[:cart_items] =  session[:cart_items] || []

    @categories = Category.all
    params[:category_id]? 
       (@products = Product.where("category_id = #{params[:category_id]}")) : 
       (@products = Product.all)
  end

  def show
    @product = Product.find(params[:id])
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, :category_id)
  end
end
