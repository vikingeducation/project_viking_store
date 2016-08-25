class UsersController < ApplicationController
  def index
    @users = User.all.order("id desc")
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(white_list_params)
    if @user.save
      flash[:success] = ["#{@user.first_name} #{@user.last_name} is created."]
      redirect_to user_path(@user)
    else
      flash.now[:danger] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user && @user.update(white_list_params)
      flash[:success] = ["#{@user.first_name} #{@user.last_name} is updated."]
      redirect_to user_path(params[:id])
    else
      flash.now[:danger] = @user.errors.full_messages
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    user = User.find(params[:id])
    if user && user.destroy
      flash[:success] = ["#{user.first_name} #{user.last_name} is deleted."]
      user.shopping_cart.destroy_all
      redirect_to users_path
    else
      flash[:danger] = user.errors.full_messages
      redirect_to session[:return_to]
      session.delete(:return_to)
    end
  end


  private
    def white_list_params
      params.require(:user).permit(:first_name,
                                   :last_name,
                                   :email,
                                   :billing_id,
                                   :shipping_id)
    end

end
