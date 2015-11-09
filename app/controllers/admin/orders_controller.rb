class Admin::OrdersController < AdminController

  def index
    if @user = valid_user
      @orders = @user.orders
    elsif params[:user_id] # user_id there but invalid
      flash[:danger] = "Invalid User!"
      @orders = Order.all.order(:user_id)
    else
      @orders = Order.all.order(:user_id)
    end
  end


  private


  def valid_user
    if params.has_key?(:user_id) && User.exists?(params[:user_id])
      User.find(params[:user_id])
    end
  end

end
