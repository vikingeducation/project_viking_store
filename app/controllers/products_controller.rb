class ProductsController < ApplicationController
  def index
    @products = params[:category_filter] ? Category.find(params[:category_filter]).products : Product.all
  end
end
