class ProductsController < ApplicationController

  def index
    @categories = Category.all

    if params[:category_id]
      @products = Product.where("category_id = #{params[:category_id]}").paginate(:page => params[:page], :per_page => 2)
    else
      @products = Product.paginate(:page => params[:page], :per_page => 6)
    end
  end

  def carts
    content = Product.find(params[:product_id])
    (session[:cart_contents] ||= [] )<< content.id
    if session[:cart_contents]
      flash.notice = "You added #{content.name}"
      redirect_to products_path
    else

    end
  end
end
