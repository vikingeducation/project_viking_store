class ProductsController < ApplicationController
  def index
    if Category.exists?(params[:category_id])
      @category = Category.find(params[:category_id])
      @products = Product.where(:category_id => @category.id)
    else
      @products = Product.all
    end
  end
end
