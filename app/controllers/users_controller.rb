class UsersController < ApplicationController
  def index
    @users = User.all
    render layout: "admin"
  end
  def new
    @user = User.new
    render layout: "admin"
  end
  def show
    @user = User.find(params[:id])
    render layout: "admin"    
  end
  def edit
    @user = User.find(params[:id])
    render layout: "admin"    
  end
  def update
    @user = User.find(params[:id])
    if @user.update(whitelisted_params)
      redirect_to @user
    else
      render 'edit'
    end
  end
  def create
    @user = User.new(whitelisted_params)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path
  end

  private
    def whitelisted_params
      params.require(:User).permit(:id, :first_name, :last_name, :email, :billing_id, :shipping_id)
    end
end
