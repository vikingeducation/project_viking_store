class ProductsController < ApplicationController

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      flash[:success] = "You've Sucessfully Created a Product!"
      redirect_to product_path(@product)
    else
      flash.now[:error] = "Error! Product wasn't created!"
      render :new
    end
  end

  def show
    @product = Product.find(params[:id])
  end


  private

  def product_params
    params.require(:product).permit(:name, :description, :sku, :price, :category_id)
  end
end
