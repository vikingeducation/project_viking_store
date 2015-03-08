class UsersController < ApplicationController

  layout "admin", only: [:index, :new, :show, :edit]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @credit_cards = @user.credit_cards
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new whitelisted_user_params
    if @user.save
      flash[:success] = "You created a new user."
      redirect_to users_path
    else
      flash[:error] = "There was an error."
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update whitelisted_user_params
      flash[:success] = "You updated this user."
      redirect_to user_path(@user.id)
    else
      flash[:error] = "Something is wrong."
      render :edit
    end
  end

  def destroy
    @user = User.find(params[:id])
    session[:return_to] ||= request.referer
    shopping_carts = @user.orders.where("checkout_date IS NULL")
    if @user.destroy!
      shopping_carts.destroy_all
      flash[:success] = "That user was deleted."
      redirect_to users_path
    else
      flash[:error] = "It didn't work."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_user_params
    params.require(:user).permit(:first_name, :last_name, :email, :shipping_id, :billing_id)
  end

end
