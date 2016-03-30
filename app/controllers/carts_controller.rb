class CartsController < ApplicationController
  before_action :set_cart

  def edit
    cast_cart_to_order
  end

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
    redirect_to edit_cart_path
  end

  def destroy
    message = {:success => 'Item removed'}
    if @cart.persisted?
      if OrderContent.exists?(params[:order_content_id]) &&
        OrderContent.find(params[:order_content_id]).destroy
      else
        message = {:error => 'Item not removed'}
      end
    else
      @cart.destroy_item(params[:product_id])
    end
    redirect_to edit_cart_path, :flash => message
  end


  private
  def assert_id
    # empty override since has no ID
    # no need to validate it
  end

  def cast_cart_to_order
    current_user || @cart = @cart.to_order
  end

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
