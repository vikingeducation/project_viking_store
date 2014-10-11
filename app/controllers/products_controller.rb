class ProductsController < ApplicationController

  def index
    @products = Product.all
    render :layout => "admin_interface"
  end

  def new
  end

  def edit
  end

  def show
    @product = Product.find(params[:id])

    @times_ordered = @product.times_ordered
    @carts_in = @product.carts_in
  end
end
