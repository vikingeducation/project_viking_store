class ProductsController < ApplicationController

  layout "admin_portal"

  def edit
    @product = Product.find(params[:id])
  end

  def index
    @column_names = ["id", 'name','price','category',"show","edit","delete"]
    @products = Product.all_in_arrays
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
    @category_name = Product.category_name(@product.category_id)
    @times_ordered = Product.times_ordered(params[:id])
    @number_of_carts_in = Product.number_of_carts_in(params[:id]).first.total
  end

  def update
    @product = Product.find(params[:id])
    @product.update_attributes(whitelisted_params)
    if @product.save
      redirect_to products_path
      flash[:notice] = "Product Updated!"
    else
      render :edit
      flash[:alert] = "Update Failed"
    end
  end

  private

  def whitelisted_params
    params[:product] ? (params.require(:product).permit(:name, :sku, :description, :price, :category_id, :created_at, :updated_at)) : (params.permit(:name, :sku, :description, :price, :category_id, :created_at, :updated_at))
  end

end
