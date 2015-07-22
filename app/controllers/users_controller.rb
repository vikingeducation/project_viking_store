class UsersController < ApplicationController

  layout 'portal'


  def index
    @users = User.get_index_data
  end


  def show
    @user = User.find(params[:id])
    @default_billing = nil
    @default_shipping = nil
  end

end
