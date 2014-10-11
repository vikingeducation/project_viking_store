class AddressesController < ApplicationController

  def index
    @addresses = Address.All
  end

  def show
    @address = Address.new
  end

  def edit
    @address = Address.find(params[:id])
  end

  def create
    @address = Address.new(whitelisted_params)

    if @address.save
      flash[:success] = "New address saved."
      redirect_to action: :index
    else
      flash.now[:error] = "Something was invalid."
      render :new
    end
  end


  def update
    @address = Address.find(params[:id])

    if @address.update(whitelisted_params)
      flash[:success] = "Updated!"
      redirect_to action: :index
    else
      flash.now[:error] = "Something went wrong."
      render :edit
    end
  end

  def destroy
    session[:return_to] ||= request.referer
    if Address.find(params[:id]).destroy
      flash[:success] = "Deleted."
      redirect_to action: :index
    else
      flash[:error] = "Something went wrong in that deletion."
      redirect_to session.delete[:return_to]
    end
  end

  private

  def whitelisted_params
    params.require(:address).permit(:street_address, :secondary_address, :city_id, :state_id, :zip_code, :user_id)
  end





end