class UsersController < ApplicationController

  layout 'portal'

  def index

    @users = User.get_index_data
    
  end

  def show

    @user = User.find(params[:id])
    @default_billing = @user.default_billing_address.print_address
    @default_shipping = @user.default_shipping_address.print_address
    @cart = @user.get_cart
    @credit_card = @user.credit_cards.first
    @user_orders = @user.get_order_history

  end

end
