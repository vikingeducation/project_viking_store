class Admin::UsersController < ApplicationController
  layout 'admin'

  def index
    @users = User.all.limit(10)
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    @addresses = addresses_as_options(@user)
  end

  def edit
    @user = User.find(params[:id])
    @shipping_addresses = addresses_as_options(@user).unshift([@user.print_shipping_address, ''])
    @billing_addresses = addresses_as_options(@user).unshift([@user.print_billing_address, ''])
  end

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      flash[:success] = "Success! The user #{@user.full_name} was created!"
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "We couldn't create the user. Please check the form for errors"
      render :new
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_params)
      flash[:success] = "Success! The user #{@user.full_name} was update!"
      redirect_to admin_user_path(@user)
    else
      flash[:error] = "We couldn't update the user. Please check the form for errors"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "Success! The user #{@user.full_name} was deleted!"
      redirect_to admin_users_path
    else
      flash[:error] = "Sorry. This user can't be deleted"
      redirect_to admin_user_path(@user)
    end
  end

  private


  def addresses_as_options(user)
    unless user.addresses.empty?
      adds = user.addresses.map do |a|
        add = a.street_address
        add += a.secondary_address ? ', ' + a.secondary_address : ''
        add += ', ' + a.city.name
        add += ', ' + a.state.name
        [add, a.id]
      end
      return adds
    end
  end

  def whitelisted_params
    if params[:user]
      params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
    end
  end


end
