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
    @product.sku = Faker::Code.ean
    if @product.save
      flash[:success] = "You just created a new product"
      redirect_to products_path
    else
      flash.now[:danger] = "It didn't work out"
      render :new
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_params)
      flash[:success] = "You just edited your product"
      redirect_to products_path
    else
      flash.now[:danger] = "Something went wrong, the product was not edited"
      render :edit
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "You have delete your product"
      redirect_to products_path
    else
      flash[:danger] = "Something went wrong, nothing was deleted"
      redirect_to(:back)
    end
  end

  private

  def whitelisted_params
    params.require(:product).permit(:name, :price, :category_id, :sku)
  end

end
