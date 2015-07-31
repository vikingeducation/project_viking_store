class OrdersController < ApplicationController


  before_action :require_login, :exclude => [:new, :create]
  before_action :require_current_user, :only => [:edit, :update]


  def new
  end


  def create
  end


  def show
    redirect_to action: :edit
  end


  def edit
    current_user
    @order = Order.find(params[:id])
  end


  def update
    @order = Order.find(params[:id])

    if @order.update(order_params)
      flash.now[:success] = "Order updated!"
    else
      flash.now[:danger] = "Error!  Please try again."
    end

    redirect_to action: :edit
  end


  private

  def require_current_user
    unless current_user == Order.find(params[:id]).user
      flash[:error] = "Access denied!!!"
      redirect_to new_session_path
    end
  end


  def order_params
    params.
      require(:order).
        permit(:id, { :order_contents_attributes => [:id, :quantity, :_destroy] } )
  end

end
