class ProductsController < ApplicationController

  def index
    @categories = Category.joins(:products).distinct

    if @category = Category.find_by_id(params[:category])
      @products = @category.products
    else
      @products = Product.all.order(:name)
    end
   
  end

end
