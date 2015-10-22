class CartsController < ApplicationController
  before_action :set_cart

  def create
    if @cart.create_items(cart_params)
      flash[:success] = 'Items added to cart'
    else
      flash[:error] = [
        'Items not added to cart',
        @cart.errors.full_messages.join(', ')
      ].join(': ')
    end
    redirect_to request.referer
  end

  def update
    if @cart.update_items(cart_params)
      flash[:success] = 'Cart updated'
    else
      flash[:error] = [
        'Cart not updated',
        @cart.errors.full_messages.join(', ')
      ].join(': ')
    end
    redirect_to request.referer
  end


  private
  def set_cart
    @cart = current_user ? current_user.cart : TempOrder.new(session)
  end

  def cart_params
    OrderContent.params_to_attributes(params.permit(
      :order_id,
      :order_content => [
        :id,
        :quantity,
        :product_id
      ]
    ))
  end
end
