class ProductsController < ApplicationController
  def index
    @products = Product.all.order(:id)
  end

  def show
    @product = Product.find(params[:id])  
  end

  
end
