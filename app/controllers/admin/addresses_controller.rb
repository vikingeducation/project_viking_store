class Admin::AddressesController < AdminController

  def index
    @user_id = params[:user_id]
    if @user_id
      @addresses = Address.all.where( user_id: @user_id )
    else
      @addresses = Address.all
    end
  end

  def new
    @address = Address.new( user_id: params['user_id'] )
  end

  def create
    @address = Address.new( address_params )

    @address.city = City.find_or_create_by( name: address_params['city_attributes']['name'] )

    if @address.save
      redirect_to admin_addresses_path, notice: "Address Created"
    else
      flash.now[:alert] = "Failed to Create Address."
      render :new
    end
  end

  def show
    @address = Address.find( params[:id] )
  end

  def edit
    @address = Address.find( params[:id] )
  end

  def update
    @address = Address.find( params[:id] )

    if @address.update(address_params)
      @address.save
      redirect_to admin_addresses_path, notice: "Address Updated!"
    else
      flash.now[:alert] = "Failed to Edit Address."
      render :edit
    end
  end

  def destroy
    @address = Address.find( params[:id] )
    if @address.destroy
      redirect_to admin_addresses_path, notice: "Address Deleted!"
    else
      redirect_to :back, alert: "Failed to Delete Address."
    end
  end

  private

  def address_params
    params.require(:address).permit(  :street_address,
                                      :secondary_address,
                                      :zip_code,
                                      :state_id,
                                      :user_id,
                                      { city_attributes: [:id, :name] }
    )
  end
end
