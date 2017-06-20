class ProductsController < ApplicationController

  def index
    @filter = params[:products_filter]
    @products = @filter.present? ? Product.of_category(@filter) : Product.all
  end

  def show
  end

end
