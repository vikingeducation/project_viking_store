class Admin::UsersController < AdminController

  layout 'portal'


  def index
    @users = User.get_index_data
  end


  def show
    @user = User.find(params[:id])
    @default_billing = @user.get_billing_address_string
    @default_shipping = @user.get_shipping_address_string
    @cart = @user.get_cart
    @credit_card = @user.credit_cards.first
    @user_orders = @user.get_order_history
  end


  def new
    @user = User.new
    @available_addresses = @user.created_addresses
  end


  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "User successfully created!"
      redirect_to @user
    else
      flash.now[:danger] = "User not saved - please try again."
      @available_addresses = @user.created_addresses
      render :new
    end

  end


  def edit
    @user = User.find(params[:id])
    @available_addresses = @user.created_addresses
  end


  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = "User successfully updated!"
      redirect_to users_path
    else
      flash.now[:danger] = "User not saved - please try again."
      @available_addresses = @user.created_addresses
      render :edit
    end
  end


  def destroy
    @user = User.find(params[:id])

    if @user.destroy
      flash[:success] = "User deleted!"
      redirect_to users_path
    else
      flash[:danger] = "Delete failed - please try again."
      redirect_to :back
    end

  end



  private



  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id)
  end

end
