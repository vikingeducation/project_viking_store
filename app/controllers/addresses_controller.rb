class AddressesController < ApplicationController
  def index
    @user = User.find_by(id: params[:user_id])
    @addresses = params[:user_id] ? render_user(params[:user_id]) : render_all
  end

  def new
    @address = Address.new
    @address.user = User.find(params[:user_id])
  end

  def create
  end

  def show
  end

  private
    def render_all
      Address.all
    end

    def render_user(user_id)
      addresses = Address.where("user_id = #{user_id}")
      if addresses.empty?
        flash[:notice] = "User not found."
        return Address.all
      else
        return addresses
      end
    end
end
