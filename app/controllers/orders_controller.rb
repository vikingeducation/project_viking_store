class OrdersController < ApplicationController

  def index
    @orders = Order.all
    # @addresses = params[:user_id] ? render_user(params[:user_id]) : render_all
  end

  def new
    # @address = Address.new
    # @address.user = User.find(params[:user_id])
  end

  def create
    # @address = Address.new(white_listed_address_params)
    # if @address.save
    #   flash[:success] = "Address is created."
    #   redirect_to addresses_path(user_id: @address.user_id)
    # else
    #   flash.now[:danger] = "Not able to create the address."
    #   render :new
    # end
  end

  def edit
    # @address = Address.find(params[:id])
  end

  def update
    # @address = Address.find(params[:id])
    # if @address.update(white_listed_address_params)
    #   flash[:success] = "Address is updated."
    #   redirect_to addresses_path(user_id: @address.user_id)
    # else
    #   flash.now[:danger] = "Not able to update the address."
    #   render :edit
    # end
  end

  def show
    # @address = Address.find(params[:id])
  end

  def destroy
    # @address = Address.find(params[:id])
    # user_id = @address.user_id if @address
    # if @address.destroy
    #   flash[:success] = "Address is destroyed."
    #   redirect_to addresses_path(user_id: user_id)
    # else
    #   flash[:danger] = "Not able to destroy the address."
    #   redirect_to @address
    # end
  end

  private

    def white_listed_address_params
      # params.require(:address).permit(:user_id, :zip_code, :street_address, :city_id, :state_id)
    end

end
