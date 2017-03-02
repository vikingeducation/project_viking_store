class Admin::AddressesController < ApplicationController
  layout 'admin'
  def index
    @user = User.exists?(params[:user_id]) if params[:user_id]
    if @user
      @user = User.find(params[:user_id])
      @addresses = @user.addresses
    else
      flash[:error] = "Sorry, that user doesn't exist. Displaying all addresses instead" if params[:user_id]
      @addresses = Address.all.limit(10)
    end
  end
end
