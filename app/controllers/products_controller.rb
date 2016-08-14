class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      flash[:success] = "Successfully created Product"
      redirect_to products_path
    else
      flash[:error] = "Something went wrong creating your product"
      redirect_to :back
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])

    if @product.update(whitelisted_params)
      flash[:success] = "Product successfully updated"
      redirect_to products_path
    else
      flash[:error] = "Something went wrong updating the product"
      render :edit
    end 
  end

  private
  def whitelisted_params
    params.require(:product).permit(:name, :description, :sku, :price, :category_id)
  end
end
