class AddressesController < ApplicationController
  before_action :find_address, only: [:show]

  def all
    @addresses = Address.all

    render "index", layout: "admin_portal"
  end

  def index
    if User.exists?(params[:user_id])
      @addresses = Address.where(user_id: params[:user_id])
      @user = User.find(params[:user_id])
    else
      flash.now[:error] = "Invalid User ID provided. Displaying all Addresses.."
      @addresses = Address.all
    end

    render layout: "admin_portal"
  end

  def show
    @user = User.find(params[:user_id])

    render layout: "admin_portal"
  end

  private

  def find_address
    @address = Address.find(params[:id])
  end
end
