class UsersController < ApplicationController

  layout 'portal'


  def index
    @users = User.get_index_data
  end


  def show
    @user = User.find(params[:id])
    @default_billing = @user.default_billing_address.stringify
    @default_shipping = @user.default_shipping_address.stringify
    @credit_card = @user.credit_cards.first
    @user_orders = @user.get_order_history
  end

end
