class ProductsController < ApplicationController

  layout "admin_portal"

  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      redirect_to products_path
      flash[:notice] = "Product Created!"
    else
      flash.now[:alert] = "Could Not Make New Product. Attribute Issues Probably."
      render :new
    end
  end

  def destroy
    Product.find(params[:id]).destroy
    redirect_to products_path
  end

  def edit
    @product = Product.find(params[:id])
  end

  def index
    @column_headers = ["ID", 'Name','Price','Category',"SHOW","EDIT","DELETE"]
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def show
    @product = Product.find(params[:id])
    if @product.category_id
      @category_name = @product.category_name(@product.category_id)
    else
      'n/a'
    end
    @times_ordered = @product.times_ordered(params[:id])
    @number_of_carts_in = @product.number_of_carts_in(params[:id]).first.total
  end

  def update
    @product = Product.find(params[:id])
    @product.update_attributes(whitelisted_params)
    @product.price = Product.format_price(params[:product][:price])
    if @product.save
      redirect_to products_path
      flash[:notice] = "Product Updated!"
    else
      flash.now[:alert] = "Update Failed"
      render :edit
    end
  end

  private

  def whitelisted_params
    params[:product] ? (params.require(:product).permit(:name, :sku, :description, :price, :category_id, :created_at, :updated_at)) : (params.permit(:name, :sku, :description, :price, :category_id, :created_at, :updated_at))
  end

end
