class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update]

  def index
    @users = User.all

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

  def edit
    render layout: "admin_portal", template: "users/edit"
  end

  def update
    if @user.update(whitelisted_user_params)
      flash[:success] = "User successfully updated."
      redirect_to @user
    else
      flash.now[:error] = "Error updating User."
      render layout: "admin_portal", template: "users/edit"
    end
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :billing_id, :shipping_id)
  end
end
