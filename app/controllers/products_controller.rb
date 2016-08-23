class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
    @category = Product.belonged_category(params[:id]).first
    @orders = Product.all_orders(params[:id])
  end

  def new
  end

  def edit
  end
end
