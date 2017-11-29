class Admin::AddressesController < ApplicationController

  layout 'admin_portal_layout'

  def index
    unless params[:user_id].nil?
      @addresses = Address.where(user_id: params[:user_id]).includes(:user, :state, :city)
      @user = user
      @orders = orders_to_this_address(@user.id)
    else
      @addresses = Address.all.includes(:orders)
    end
  end


  def show
    @address = Address.where(id: params[:id]).includes(:user, :state, :city).first
    @user_name = user_full_name
  end


  private

  def orders_to_this_address(users_id)
    Order.where(user_id: users_id).
          group(:user_id).
          where.not(checkout_date: nil).
          count.
          values.
          first
  end


  def user
    User.find(params[:user_id])
  end


  def user_full_name
    @address.user.first_name + " " + @address.user.last_name
  end




end
