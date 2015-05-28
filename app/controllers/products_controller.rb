class ProductsController < ApplicationController
  layout "admin"

  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_product_params)
    if @product.save
      flash[:success] = "Product created!"
      redirect_to products_path
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/products/new"
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product obliterated!"
      redirect_to products_path
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/products"
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def show
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_product_params)
      flash[:success] = "Category updated!"
      redirect_to products_path
    else
      flash[:error] = @product.errors.full_messages.to_sentence
      render "/products/edit"
    end
  end

  def whitelisted_product_params
    params.require(:product).permit(:name, :sku, :description, :price, :category_id)
  end
end
