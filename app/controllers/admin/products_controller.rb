module Admin
  class ProductsController < ApplicationController
    layout "admin"
    before_action :set_product, only: [:show, :edit, :destroy, :update]

    def index
      @products = Product.all
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      @product.price = clean_price

      if @product.save
        flash[:success] = "#{@product.name} Created!!"

        redirect_to admin_products_path
      else
        render :new
      end
    end

    def update
      @product.price = clean_price
      if @product.update(product_params)
        flash[:success] = "Product #{@product.name} Has Been Updated!!!"
        redirect_to admin_products_path
      else
        flash.now[:error] = "Something Went Wrong!"
        render :edit
      end
    end

    def destroy
      if @product.destroy
        flash[:success] = "Product #{@product.name} Has Been Deleted!!!"
      else
        flash.now[:error] = "Something Went Wrong!"
      end

      redirect_to admin_products_path
    end

    private

    def product_params
      params.require(:product).permit(:name, :category_id)
    end

    def clean_price
      params[:product][:price].gsub('$', '')
    end

    def set_product
      @product = Product.find(params[:id])
    end
  end
end
