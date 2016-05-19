class OrdersController < ApplicationController
  def index
    index_one_or_many_users
  end

  def show
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
    @user = User.find(params[:user_id])
  end

  def create
    @order = Order.new(whitelisted_params)
    @user = User.find(params[:user_id])
    if @order.save
      flash[:success]= "You created an order"
      redirect_to edit_user_order_path(@user, @order)
    else
      flash[:danger] = "Something went wrong"
      render :new
    end
  end

  def edit
    @order = Order.find(params[:id])
    @user = User.find(params[:user_id])
  end

  private

  def whitelisted_params
    params.require(:order).permit(:billing_id, :shipping_id, :credit_card_id, :user_id)
  end

  def index_one_or_many_users
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
