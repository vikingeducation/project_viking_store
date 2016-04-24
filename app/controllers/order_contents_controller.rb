class OrderContentsController < ApplicationController

  # Adding item to cart as long as the order doesn't have that item in there already.
  def create
    product_id = params[:product_id]
    if signed_in_user?
      # We want to add items straight into the the users items shopping cart.
      cart = current_user.orders.where(:checkout_date => nil).first
      if order_includes_product?(cart, product_id)
        #current_user.orders.where(:checkout_date => nil).first.order_contents.create(:product_id => params[:product_id])
        flash[:notice] = "Item already in cart!"
      else
        add_item_to_cart(cart, product_id)
        flash[:notice] = "Item added to cart!"
      end
    else
      session[:shopping_cart_items] ||= []
      session_cart = session[:shopping_cart_items]
      if session_cart.empty?
        add_item_to_cart(session[:shopping_cart_items], product_id)
        flash[:notice] = "Item added to cart!"
      else
        if order_includes_product?(session_cart, product_id)
          flash[:notice] = "Item already in cart!"
        else
          flash[:notice] = "Item added to cart!"
          add_item_to_cart(session_cart, product_id)
        end
      end
    end
    redirect_to root_path
  end

  def add_item_to_cart(order, product_id)
    unless order.persisted?
      order << OrderContent.new(:product_id => product_id)
    else
      order.order_contents.create(:product_id => product_id)
    end
  end

  def order_includes_product?(order, product_id)
    unless order.persisted?
      order.each do |order_content|
        return true if order_content["product_id"] == product_id
      end
      false
    else
      order.products.each do |product|
        return true if product.id == product_id.to_i
      end
      false
    end
  end

end
