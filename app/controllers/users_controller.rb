class UsersController < ApplicationController
  before_action :find_user, only: [:show]

  def index
    @users = User.all
    @users_data = {}

    @users.each do |user|
      @users_data[user.id.to_s] = {
        city: user.addresses.first.city.name,
        state: StatesHelper::STATE_POSTAL_CODES.key(user.addresses.first.state.name),
        num_placed_orders: user.num_placed_orders,
        last_order_date: user.last_order_date
      }
    end

    render layout: "admin_portal"
  end

  def show
    render layout: "admin_portal", template: "users/show"
  end

  def new
    @user = User.new

    render layout: "admin_portal", template: "users/new"
  end

  def create
    @user = User.new(whitelisted_user_params)

    if @user.save
      flash[:success] = "User successfully created."
      redirect_to @user
    else
      flash.now[:error] = "Error creating User."
      render layout: "admin_portal", template: "users/new"
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number)
  end
end
