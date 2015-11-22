class OrdersController < ApplicationController

  def create
    load_session_cart
    save_session_cart
    redirect_to root_path
  end


  private


  def load_session_cart
    @cart = Hash.new(0)
    @cart.merge!(session[:cart]) if session[:cart]   
  end


  def save_session_cart
    order_params[:order_contents_attributes].each do |k, param|
      @cart[param["product_id"]] += 1
    end
    session[:cart] = @cart
  end


  def order_params
    params.require(:order).permit(:shipping_id, :billing_id, :credit_card_id, 
                                  :user_id, :status, order_contents_attributes: 
                                  [:quantity, :product_id, :id, :_destroy])
  end

end
