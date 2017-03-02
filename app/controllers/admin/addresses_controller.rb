class Admin::AddressesController < ApplicationController
  layout 'admin'
  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @addresses = Address.all.limit(10)
  end
end
