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
    @total = 0
    @cart.each do |product, quantity|
      price = Product.find(product.to_i).price
      @total += price * quantity.to_i
    end
  end

  def update
    @cart = session[:cart]
    if update_cart
      flash[:success] = "You Succesfully Updated your Cart"
      redirect_to root_path
    end
  end

  private

  def update_cart
    params[:products].each do |product, quantity|
      if quantity.to_i > 0
        session[:cart][product] = quantity
      else
        session[:cart].delete(product)
      end
    end 
  end

end
