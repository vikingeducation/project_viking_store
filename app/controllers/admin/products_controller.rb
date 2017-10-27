class Admin::ProductsController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end


  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      redirect_to admin_product_path(@product)
    else
      render :new
    end
  end


  def edit
    set_product
  end


  def show
    set_product
  end


  def update
    set_product
    if @product.update(whitelisted_params)
      redirect_to admin_product_path(@product)
    else
      render :edit
    end
  end


  def destroy
    set_product
    @product.destroy
    redirect_to admin_products_path
  end



  private


  def set_product
    @product = Product.find(params[:id])
  end

  def whitelisted_params
    params.require(:product).permit(:name, :price, :category_id)
  end

end
