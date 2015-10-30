class OrdersController < ApplicationController

  before_action :require_active_cart, :only => [:show, :edit, :destroy, :checkout]

  before_action :require_login, :exclude => [:new, :create]
  before_action :require_current_user, :only => [:edit, :update, :destroy, :checkout, :finalize]

  def show

    redirect_to action: :edit

  end

  def edit

    current_user
    @order = Order.find(params[:id])

  end

  def destroy

    if current_user.get_cart.destroy!
      flash[:success] = "Order successfully deleted"
      redirect_to root_path
    else
      flash[:danger] = "Order failed to delete - please try again."
      redirect_to :back
    end

  end

  def checkout

    @order = Order.find(params[:id])
    @order.billing_card = @order.user.credit_cards.first || @order.build_billing_card
    @shipping_charge = 10
    @tax = 10

  end

  def finalize

    @order = Order.find(params[:id])

    # finalize if card is saved, addresses are selected, and cart is not empty
    if @order.update(checkout_params)
      # needs review, checkout_date in checkout_params throws nil error
      @order.checkout_date = DateTime.now
      @order.save!
      flash[:success] = "Order successfully made!"
      redirect_to root_path
    else
      flash.now[:danger] = "Order failed to check out - please try again."
      @shipping_charge = 10
      @tax = 10
      render :checkout
    end

  end

  def update

    # bypass name method on nil class when removing items with checkbox
    # create filtered_params to store nested order_contents_attributes
    # manually destroy the ordercontent
    # needs review
    filtered_params = {:order_contents_attributes => {}}
    order_params[:order_contents_attributes].each do |content|
      if content[1][:_destroy] == "1"
        test = OrderContents.find(content[1][:id].to_i)
        test.destroy
      else
        filtered_params[:order_contents_attributes].store content[0],content[1]
      end

    end

    @order = Order.find(params[:id])

    # feed in filtered_params instead
    if @order.update(filtered_params)
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
                                  { :order_contents_attributes => [:id, :quantity, :_destroy] } )

  end

  def checkout_params

    params.require(:order).
            permit( :shipping_id,
                    :billing_id,
                    { :billing_card_attributes => [:card_number,
                                                   :exp_month,
                                                   :exp_year,
                                                   :user_id] } )
            
  end
  
end
