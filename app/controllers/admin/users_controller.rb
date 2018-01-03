class Admin::UsersController < ApplicationController

  layout 'admin_portal_layout'

  def index
    @users = User.all
  end


  def new
    @user = User.new
    @address = @user.addresses.build
  end


  def create
    @user = User.new(whitelisted_params)
    @user.save
    shipping = @user.addresses.create(whitelisted_params[:shipping_id])
    billing = @user.addresses.create(whitelisted_params[:billing_id])
    @user.billing_id = billing.id
    @user.shipping_id = shipping.id
    if @user.save
      flash[:success] = "User ##{@user.id} Successfully Saved!"
      redirect_to admin_users_path
    else
      flash[:danger] = "User Could Not Be Saved See Errors On Form"
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
    if CreditCard.exists?(user_id: @user.id)
      @cc = CreditCard.find(@user.id)
    end
    @orders = Order.where(user_id: @user.id)
    @shopping_cart = @orders.where(checkout_date: nil).ids
    unless @user.billing_id.nil?
      @billing_addy = Address.find(@user.billing_id)
    end
    unless @user.shipping_id.nil?
      @shipping_addy = Address.find(@user.shipping_id)
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(whitelisted_params)
      flash[:success] = "User ##{@user.id} Successfully Updated!"
      redirect_to admin_user_path(params[:id])
    else
      flash[:danger] = "User ##{@user.id} Could Not Be Updated See Errors On Form"
      render :edit
    end
  end


  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User ##{@user.id} Successfully Deleted"
      redirect_to admin_users_path
    else
      flash[:danger] = "User ##{@user.id} Could Not be Deleted"
      redirect_to admin_user_path(@user)
    end
  end


  private


  def create_address_from_params(user, params)
    Address.new(user_id: user.id,
                   street_address: params[:street_address],
                   zip_code: params[:zip_code],
                   city_id: params[:city_id],
                   state_id: params[:state_id],
                 ).save
  end

  def whitelisted_params
    params.require(:user).permit(:first_name, :last_name, :email, :telephone, { shipping_id: [:id, :street_address, :city_id, :state_id, :zip_code, :_destroy] },
                                                                              { billing_id: [:id, :street_address, :city_id, :state_id, :zip_code, :_destroy] })
  end


end
