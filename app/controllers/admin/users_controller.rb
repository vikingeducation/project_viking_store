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
    @addresses = addresses_as_options(@user)
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
      return adds << ['Select an Address', '']
    end
  end

  def whitelisted_params
    if params[:user]
      params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
    end
  end


end
