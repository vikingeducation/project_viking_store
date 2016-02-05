class Admin::AddressesController < ApplicationController

  def index
    @user = User.find(params[:user_id])
    @addresses = @user.addresses
  end

  def new
    @address = Address.new
  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

end