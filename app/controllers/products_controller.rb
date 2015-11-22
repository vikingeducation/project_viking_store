class ProductsController < ApplicationController

  def index
    @categories = Category.joins(:products).distinct
    @cart = Order.new
    @cart.order_contents.build

    if @category = Category.find_by_id(params[:category])
      @products = @category.products
    else
      @products = Product.all.order(:name)
    end
   
    #@test = session[:cart]
  end


  private


end
