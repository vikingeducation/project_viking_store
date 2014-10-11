class OrdersController < ApplicationController

  def index
    @orders = Order.all
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def show
    @order = Order.find(params[:id])
    @user = @order.user
  end

  def edit
    @order = Order.find(params[:id])
  end

  def new
    @order = Order.new
  end

  def create
    @Order = Order.new(whitelisted_params)

    if @Order.save
      flash[:success] = "New order saved."
      redirect_to action: :index
    else
      flash.now[:error] = "Something was invalid."
      render :new
    end
  end

  def update
    @order = Order.find(params[:id])

    if @order.update(whitelisted_params)
      flash[:success] = "Updated!"
      redirect_to action: :index
    else
      flash.now[:error] = "Something went wrong."
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if Order.find(params[:id]).destroy
      flash[:success] = "Deleted."
      redirect_to action: :index
    else
      flash[:error] = "Something went wrong in that deletion."
      redirect_to session.delete(:return_to)
    end
  end

  private

  def whitelisted_params
    check_city

    params.require(:order).permit(:checked_out, :user_id,
                               :shipping_id, :billing_id, :checkout_date)
  end

  def check_city
    city = params[:address][:city]

    if City.find_by(name: city)
      params[:address][:city_id] = City.find_by(name: city).id
    else
      c = City.create(name: city)
      params[:address][:city_id] = c.id
    end
  end




end
