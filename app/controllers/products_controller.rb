class ProductsController < ApplicationController

  def index
    @filter = params[:products_filter]
    @products = @filter.present? ? Product.filter_by_category(@filter) : Product.all
  end


end
