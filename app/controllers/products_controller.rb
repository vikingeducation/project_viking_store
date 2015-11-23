class ProductsController < ApplicationController

  def index
    @categories = Category.joins(:products).distinct
    build_cart
    
    if @category = Category.find_by_id(params[:category])
      @products = @category.products.paginate(:page => params[:page])
    else
      @products = Product.all.paginate(:page => params[:page])
    end
   
    #@test = session[:cart]
  end


  private

  def build_cart
    user = current_user
    if user && user.cart
      @cart = user.cart
    else
      @cart = Order.new
    end
    @cart.order_contents.build
  end


end
