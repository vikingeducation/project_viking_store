class OrdersController < ApplicationController

  def create
    user = current_user
    if user
      @cart = user.orders.new(order_params)
      if @cart.save
        flash[:info] = "Shopping cart updated"
      else
        flash[:danger] = "Oops, something went wrong!"
      end
    else
      update_session_cart
      flash[:info] = "Shopping cart updated"
    end
    redirect_to shopping_cart_path
  end


  def edit
    user = current_user
    if user && user.cart.products.any?
      @cart = user.cart
    elsif session[:cart]
      build_cart_from_session
    end
  end


  def update
    user = current_user
    if user
      @cart = Order.find(order_params[:id])
      if @cart.update(order_params)
        flash[:info] = "Shopping Cart Updated."
      else
        flash[:danger] = "Oops, something went wrong!"
      end
    else
      update_session_cart
      flash[:info] = "Shopping Cart Updated."
    end    
    redirect_to shopping_cart_path
  end


  private


  def update_session_cart
    @session_cart = Hash.new(0)
    @session_cart.merge!(session[:cart]) if session[:cart] 
    order_params[:order_contents_attributes].each do |k, param|
      @session_cart[param["product_id"]] = param["quantity"]
      remove_item?(param)
    end
    session[:cart] = @session_cart
    session.delete(:cart) if @session_cart.empty?
  end


  def order_params
    params.require(:order).permit(:id, :shipping_id, :billing_id, :credit_card_id, 
                                  :user_id, :status, order_contents_attributes: 
                                  [:quantity, :product_id, :id, :_destroy])
  end


  def remove_item?(param)
    if param["_destroy"] == "1" || param["quantity"] == "0"
      @session_cart.delete(param["product_id"])
    end
  end


  def build_cart_from_session
    @cart = Order.new
    session[:cart].each do |p_id, q|
      @cart.order_contents.build(product_id: p_id, quantity: q)
    end
  end

end
