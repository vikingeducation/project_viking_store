class Store::ProductsController < ApplicationController

  def index
    if params[:category]
      @category = Category.find(params[:category][:id])
      @products = Product.containing_only_category(@category)
    else
      @products = Product.all
    end
  end
end
