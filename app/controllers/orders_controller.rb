class OrdersController < ApplicationController

  before_action :require_active_cart, :only => [:show, :edit, :checkout]

  before_action :require_login, :exclude => [:new, :create]
  before_action :require_current_user, :only => [:edit, :update, :checkout]

  def show

    redirect_to action: :edit

  end

  def checkout

    @order = Order.find(params[:id])

  end

  def edit

    current_user
    @order = Order.find(params[:id])

  end

  def update

    @order = Order.find(params[:id])

    if @order.update(order_params)
      flash[:success] = "Order updated successfully!"
    else
      flash[:danger] = "Order failed to update - please try again."
    end

    redirect_to action: :edit

  end

  private

  def require_current_user

    unless current_user == Order.find(params[:id]).user
      flash[:danger] = "Access Denied."
      redirect_to new_session_path
    end

  end

  def require_active_cart

    unless session[:visitor_cart] || (signed_in_user? && current_user.has_cart?)
      
      flash[:danger] = "Cart is empty. You must add products to access your cart."
      redirect_to root_path

    end

  end

  def order_params

    params.require(:order).permit(:id,
                                  { :order_contents_attributes => [
                                      :id,
                                      :quantity,
                                      :_destroy ] } )

  end
  
end
