class Admin::ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(whitelisted_params)
    if @product.save
      flash[:success] = "Product created successfully."
      redirect_to admin_products_path
    else
      flash.now[:error] = "Failed to create product."
      render 'new'
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(whitelisted_params)
      flash[:success] = "Product updated successfully."
      redirect_to admin_products_path
    else
      flash.now[:error] = "Failed to update product."
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id])
    if @product.destroy
      flash[:success] = "Product destroyed successfully."
      redirect_to admin_products_path
    else
      flash.now[:error] = "Failed to destroy product."
      render 'index'
    end
  end

  private

  def whitelisted_params
    params.require(:product).permit(:name, :sku, :description, :price, :category_id)
  end
end