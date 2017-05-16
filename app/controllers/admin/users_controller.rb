class Admin::UsersController < ApplicationController
  layout "admin"

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @demographic_info = demographic_info(@user)
    @credit_cards = @user.credit_cards
    @order_history = Order.value_per_order.where(:user_id => params[:id])
  end

  def new
    @user = User.new
    @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "User created successfully"
      redirect_to admin_users_path
    else
      @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
      flash.now[:danger] = "Failed to create user"
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "User updated successfully"
      redirect_to admin_user_path(@user.id)
    else
      @address_options = @user.addresses.map{ |a| [full_address(a), a.id] }
      flash.now[:danger] = "Failed to update user"
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    carts = @user.orders.where(:checkout_date => nil)
    # delete all shopping carts, but not completed orders
    carts.destroy_all
    @user.destroy
    flash[:success] = "User deleted successfully"
    redirect_to admin_users_path
  end

  # ----------------------------------------------------------------
  # Helpers
  # ----------------------------------------------------------------

  def user_params
    params.require(:user).permit(
      :first_name, :last_name, :email, :billing_id, :shipping_id)
  end

  def full_address(address)
    return "No address" if address.nil?
    addr = [address.street_address,
            address.secondary_address,
            address.city.name,
            address.state.name].select{ |x| !x.nil? }
    addr.join(", ")
  end

  def demographic_info(user)
    {
      "full_name" => "#{user.first_name} #{user.last_name}",
      "First Name" => user.first_name,
      "Last Name" => user.last_name,
      "Email" => user.email,
      "Telephone" => "No phone",
      "Default Billing Address" => full_address(user.default_billing_address),
      "Default Shipping Address" => full_address(user.default_shipping_address)
    }
  end

end
