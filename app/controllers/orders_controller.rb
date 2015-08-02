class OrdersController < ApplicationController

  before_action :require_active_cart, :only => [:show, :edit, :checkout]

  before_action :require_login, :exclude => [:new, :create]
  before_action :require_current_user, :only => [:edit, :update, :checkout, :finalize]



  def show
    redirect_to action: :edit
  end


  def edit
    current_user
    @order = Order.find(params[:id])
  end


  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      flash.now[:success] = "Order updated!"
    else
      flash.now[:danger] = "Error!  Please try again."
    end

    redirect_to action: :edit
  end


  def checkout
    @order = Order.find(params[:id])
    @order.billing_card = @order.user.credit_cards.first || @order.build_billing_card
    @shipping_charge = 12
    @tax = 12
  end


  def finalize
    @order = Order.find(params[:id])


    # only continue if Card is saved and Addresses are selected and Cart isn't empty

    if @order.update(checkout_params)
      flash[:success] = "Order completed!  Thank you!"
      redirect_to root_path
    else
      flash.now[:danger] = "Error!  Please try again."
      render :finalize
    end

  end



  private


  def require_current_user
    unless current_user == Order.find(params[:id]).user
      flash[:danger] = "Access denied!!!"
      redirect_to new_session_path
    end
  end


  def require_active_cart
    unless current_user.has_cart?
      flash[:danger] = "Cart is empty!  Add products before looking in your cart."
      redirect_to root_path
    end
  end


  def order_params
    params.
      require(:order).
        permit( :id,
                { :order_contents_attributes => [:id, :quantity, :_destroy] }
              )
  end


  def checkout_params
    params.
      require(:order).
        permit( :shipping_id,
                :billing_id,
                :checkout_date,
                { :billing_card_attributes => [:card_number, :exp_month, :exp_year, :user_id] } )
  end
end
