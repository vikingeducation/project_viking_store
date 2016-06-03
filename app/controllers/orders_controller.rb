class OrdersController < ApplicationController
  layout "shop"
  def edit
    update_db_cart
    @order = current_user.cart
    if current_user.credit_cards.present?
      @order.credit_card = current_user.credit_cards.first
    else
      @order.credit_card = current_user.credit_cards.build(user_id: @order.user.id)
    end

    @total = 0
    @order.products.each do |product|
      @total += product.price * @order.order_contents.where(product_id: product.id).first.quantity
    end
  end

  def update
    @order = current_user.cart

    if current_user.credit_cards.present?
      @order.credit_card = current_user.credit_cards.first
    else
      @order.credit_card = current_user.credit_cards.build(whitelisted_credit_card)
      unless @order.credit_card.save
        flash[:error] = "Something wrong about this card"
      end
    end    

    @order.checkout_date = Time.now
    if @order.update_attributes(whitelisted_params) && complete_payment_info
      flash[:success]= "You created a New Order"

      # Re-create a new shopping cart
      Order.create(:user_id => current_user.id)
      session[:cart] = {}
      redirect_to root_path
    else
      flash[:danger]= "Something went wrong"
      render :new
    end
  end

  def destroy
    @order = current_user.cart
    if @order.order_contents.destroy_all
      session[:cart] = {}
      flash[:success] = "You deleted the order"
      redirect_to root_path
    else
      flash[:danger] = "Something went wrong"
      redirect_to(:back)
    end
  end

  private

  def whitelisted_credit_card
    params[:credit_card][:user_id] = current_user.id
    params.require(:credit_card).permit(:id, :card_number, :exp_month, :exp_year, :ccv, :user_id)
  end

  def whitelisted_params
    params.require(:order).permit(:checkout_date, :billing_id, :shipping_id, :credit_card_id)
  end

  def complete_payment_info
    @order.billing_id && @order.shipping_id && @order.credit_card_id
  end

end
