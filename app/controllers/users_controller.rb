class UsersController < ApplicationController
  before_action :restrict_to_signed_in, :except => [:new, :create]
  before_action :set_user

  def new
    @user.build_billing
    @user.build_shipping
  end

  def edit
    @user.addresses.build
  end

  def create
    if @user.update(user_params)
      sign_in(@user)
      TempOrder.merge(session, @user.cart)
      flash[:success] = 'User created and signed in'
      redirect_to edit_user_path(@user)
    else
      flash.now[:error] = 'User not created'
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User updated'
      redirect_to edit_user_path(@user)
    else
      flash.now[:error] = 'User not updated'
      render :edit
    end
  end

  def destroy
    if @user.destroy && sign_out
      flash[:success] = 'User destroyed and signed out'
      redirect_to root_path
    else
      flash[:error] = 'User not destroyed, users with placed orders cannot be destroyed'
      redirect_to request.referer
    end
  end


  private
  def set_user
    @user = User.exists?(params[:id]) ? User.find(params[:id]) : User.new
  end

  def user_params
    address_attributes = [
      :id,
      :street_address,
      :secondary_address,
      :zip_code,
      :city_id,
      :state_id
    ]
    params.require(:user)
      .permit(
        :email,
        :first_name,
        :last_name,
        :billing_id,
        :shipping_id,
        :billing_attributes => address_attributes,
        :shipping_attributes => address_attributes,
        :addresses_attributes => address_attributes << :_destroy
      )
  end
end
