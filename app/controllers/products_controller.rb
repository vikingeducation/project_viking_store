class ProductsController < ApplicationController

  def index
    @categories = Category.joins(:products).distinct
    @cart = Order.new
    @cart.order_contents.build

    if @category = Category.find_by_id(params[:category])
      @products = @category.products.paginate(:page => params[:page])
    else
      @products = Product.all.paginate(:page => params[:page])
    end
   
    #@test = session[:cart]
  end


  private


end
