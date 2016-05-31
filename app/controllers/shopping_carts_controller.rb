class ShoppingCartsController < ApplicationController
  layout "shop"

  def create
    session[:cart] ||= {}
    product = params[:product]

    if Product.exists?(product) && session[:cart][product]
      session[:cart][product] += 1
      flash[:success] = "Added one more product to the cart"
    elsif Product.exists?(product)
      session[:cart][product] = 1
      flash[:success] = "Added a new product to the cart"
    else
      flash[:danger] = "Invalid product"
    end

    redirect_to products_path({filter_category: params[:filter_category]})
  end

  def edit
    @cart = session[:cart]
  end

end
