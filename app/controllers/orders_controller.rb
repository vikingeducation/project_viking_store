class OrdersController < ApplicationController
  layout "shop"
  def edit
    update_db_cart
    @order = current_user.cart
    @order.credit_card = current_user.credit_cards.build
    @total = 0
    @order.products.each do |product|
      @total += product.price * OrderContent.where(product_id: product.id, order_id: @order.id).first.quantity
    end
  end

  def update
    @order = current_user.cart
    @order.checkout_date = Time.now
    if @order.update_attributes(whitelisted_params)
      Order.create(:user_id => current_user.id)
      flash[:success]= "You created a New Order"
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

  def whitelisted_params
    params.require(:order).permit(:checkout_date, :billing_id, :shipping_id, :credit_card_id)
  end

end
