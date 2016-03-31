class UsersController < ApplicationController
  
  layout 'admin_portal'

  def create
    @user = User.new(whitelisted_params)
    if @user.save
      redirect_to users_path
      flash[:notice] = "User Created!"
    else
      flash.now[:alert] = "Could Not Make New User. Attribute Issues Probably."
      render(:new)
    end
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to users_path
    flash[:notice] = "User Destroyed!"
  end

  def edit
    @user = User.find(params[:id])
  end

  def index
    @column_headers = ["ID","Name","Joined","City","State","Orders","Last Order Date", "SHOW", "EDIT", "DELETE"]
    @users = User.all
  end

  def new
    @user = User.new
    @user_orders_table_headers = ["ID","Order Date","Order Value","Status","SHOW", "EDIT", "DELETE"]
  end

  def show
    @user = User.find(params[:id])
    @user_orders_table_headers = ["ID","Order Date","Order Value","Status","SHOW", "EDIT", "DELETE"]
    @orders = Order.where(:user_id => params[:id])
  end

  def update
    @user = User.new(whitelisted_params)
    if @user.save
      redirect_to users_path
      flash[:notice] = "User Updated!"
    else
      flash.now[:alert] = "Could Not Update User. Attribute Issues Probably."
      render(:edit)
    end
  end

  private

  def whitelisted_params
    params[:user] ? (params.require(:user).permit(:first_name, :last_name, :email, :billing_id, :shipping_id, :created_at, :updated_at)) : (params.permit(:first_name, :last_name, :email, :billing_id, :shipping_id, :created_at, :updated_at))
  end
end