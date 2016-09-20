class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @orders = @user.orders
    @billing_address = "#{@user.default_billing_address.street_address}, " +
                       "#{@user.default_billing_address.city.name}, "+
                       "#{@user.default_billing_address.state.name}" if @user.default_billing_address
    @shipping_address = "#{@user.default_shipping_address.street_address}, " +
                       "#{@user.default_shipping_address.city.name}, "+
                       "#{@user.default_shipping_address.state.name}" if @user.default_shipping_address
  end

  def addresses
    @user = User.find(params[:id])
    @addresses =  @user.addresses
    @addresses_str = @addresses.map do |address|
      "#{address.street_address}, " +
      "#{address.city.name}, "+
      "#{address.state.name}"
    end
  end

  def new
    @user = User.new
  end

  def create
    new_user = User.new(whitelist_params)
    if new_user.save
      flash[:success] = "yeah, new user created!"
      redirect_to users_path
    else
      @user = new_user
      show_errors(@user.errors.messages)
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @addresses = []
    @user.addresses.each do |address|
      @addresses << ["#{address[:street_address]}, #{address.city[:name]}, #{address.state[:name]}",
                      address[:id]]
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update(whitelist_params)
      flash[:success] = "yeah, user updated!"
      redirect_to user_path(@user)
    else
      show_errors(@user.errors.messages)
      render :edit
    end
  end



  def destroy
    user = User.find(params[:id])
    if user
      user.destroy
      flash[:success] = "user #{user.first_name} #{user.last_name} deleted!"
      redirect_to users_path
    else
      render :index
    end
  end

  private
  def whitelist_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

  def show_errors(messages)
    flash.now[:danger] = []
    messages.each do |type, errors|
      errors.each do |err|
        flash.now[:danger] << type.to_s.titleize + " " + err
      end
    end
  end
end
