module Admin
  class ProductsController < ApplicationController
    layout "admin"
    before_action :set_product, only: [:show]

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
        flash[:success] = "#{@product} Created!!"

        redirect_to products_path
      else
        render :new
      end
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
