class StoreController < ApplicationController

  layout "member"

  def home
    session[:cart] ||= {}
    @categories = Category.all
    if params[:cat_id]
      @products = Category.find(params[:cat_id]).products
    else
      @products = Product.all
    end
  end

  def add_to_cart
    session[:cart][params[:product_id]] ||= 0
    session[:cart][params[:product_id]] += 1
    flash[:success] = "The product has been successfully added to your cart"
    redirect_to root_path
  end




end
