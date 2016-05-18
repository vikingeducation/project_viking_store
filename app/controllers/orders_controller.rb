class OrdersController < ApplicationController
  def index
    one_user_or_all_users
  end




  private

  def one_user_or_all_users
    if params[:user_id] 
      if User.exists?(params[:user_id])
        @orders = Order.where(user_id: params[:user_id])
        @user = User.find(params[:user_id])   
      else
        flash.now[:danger] = "There is no user with the ID : #{params[:user_id]}"
        @orders = Order.order(:id => :asc).limit(100)
      end
    else
      @orders = Order.order(:id => :asc).limit(100)
    end
  end

end
