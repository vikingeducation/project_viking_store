class CartController < ApplicationController

  def edit
    product = Product.find(params[:product_id]).name
    added_cart = Cart::add_unique_item(session,params[:product_id])
    if !added_cart
      flash[:alert] = "Product #{product} already in your Cart!"
    else
      puts "Cart items are #{session[:cart_items]}"
      flash[:success] = "Added #{product} to your Cart!"
      session[:cart_items] = added_cart
    end  
    redirect_to products_path
  end

  def update
    session[:cart_items]  << params[:product_id]
    product = Product.find(params[:product_id]).name
    flash[:success] = "Added #{product} to your Cart!"
    redirect_to products_path
  end

end
