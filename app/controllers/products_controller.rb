class ProductsController < ApplicationController
  def index
    @products = params[:category_filter] ? Category.find(params[:category_filter]).products : Product.all

    @category_filter = Category.all.map {|cat| [cat.name, cat.id] }
  end
end
