class UsersController < ApplicationController
  def index
    @users = User.all
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
      flash[:success] = ["#{user.first_name} #{user.last_name} is created."]
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
