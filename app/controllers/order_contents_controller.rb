class OrderContentsController < ApplicationController

  # Adding item to cart as long as the order doesn't have that item in there already.
  def create
    unless session[:shopping_cart_items]
      session[:shopping_cart_items] = []
      add_item_to_cart(session[:shopping_cart_items], params[:product_id])
      flash[:notice] = "Item added to cart!"
      redirect_to root_path
    else
      # Checking whether our shopping cart already has that item, if it doesn't, add it into the cart, and flash a message saying it's been added.
      # If it does, flash a message stating that the itemis already in the cart, either way, redirect back the index_path.
      unless order_includes_product?(session[:shopping_cart_items], Product.find(params[:product_id]))
        add_item_to_cart(session[:shopping_cart_items], params[:product_id])
        flash[:notice] = "Item added to cart!"
        redirect_to root_path
      else
        flash[:notice] = "Item already in cart!"
        redirect_to root_path
      end
    end
  end

  def add_item_to_cart(order, product_id)
    order << OrderContent.new(:product_id => product_id)
  end

  def order_includes_product?(order, product)
    order.each do |order_content|
      return true if order_content["product_id"] == product.id
    end
    false
  end

end
