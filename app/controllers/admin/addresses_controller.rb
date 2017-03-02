class Admin::AddressesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
  end
end
