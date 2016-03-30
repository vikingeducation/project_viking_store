class CartsController < ApplicationController

  def create
    session[:cart] ||= {}
    product_id = params[:product_id]

    if Product.exists?(product_id) && session[:cart][product_id]
      session[:cart][product_id] += 1
      flash[:success] = "Added another #{Product.find(product_id).name} to your cart"
    elsif Product.exists?(product_id)
      session[:cart][product_id] = 1
      flash[:success] = "Added a #{Product.find(product_id).name} to your cart"
    else
      flash[:error] = "Product not added"
    end

    redirect_to products_path(product_filter: params[:product_filter])
  end

  def edit
    @cart = session[:cart]
  end
end
