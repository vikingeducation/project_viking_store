class AddressesController < ApplicationController

  def index
    @addresses = Address.all
    @user = User.find(params[:user_id]) if params[:user_id]
  end

  def show
    @address = Address.find(params[:id])
    @user = @address.user
  end

  def edit
    @address = Address.find(params[:id])
    @user = @address.user
  end

  def new
    @user = User.find(params[:user_id])
    @address = Address.new
  end

  def create
    @user = User.find_by(params[:user_id])
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
    check_city

    params.require(:address).permit(:street_address, :secondary_address,
                               :city_id, :state_id, :zip_code, :user_id)
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