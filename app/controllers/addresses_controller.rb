class AddressesController < ApplicationController
  def index
    @addresses = Address.all
    if params[:user_id] && User.exists?(params[:user_id])
      @user = User.find(params[:user_id])
    end
  end
end
