class UsersController < ApplicationController

  layout 'front_facing'

  def create
    add_city_id_to_params
    @user = User.new(whitelisted_params)
    # Now to figure out this default address business...
    # I was thinking if we save the user then the addresses will save as well and therefore their ids will be available. 
    # Also at this time the params will be available, so if we can have the params store the the address key as the user's billiing_id and shipping_id, we could solve it from that, so first I have to get the radio buttons to send the index as the value.
    if @user.save
      # at this point the addresses will have been saved...
      # I want to know if @user.addresses[@user.billing_id.to_i] will return the correct address
      @user.billing_id = @user.addresses[@user.billing_id.to_i].id
      @user.shipping_id = @user.addresses[@user.shipping_id.to_i].id
      @user.save
    else
      asdfa
    end
  end

  def new
    @user = User.new
  end

  private

  def add_city_id_to_params
    # All the addresses keys are from 0 upwards which means we could iterate with a .times enumerator pretty easy
    params["user"]["addresses_attributes"].size.times do |x| 
      # This will return the city that was entered for the address with x as the key.
      # Now I want to run that through the City class method that returns an id.
      address = params["user"]["addresses_attributes"][x.to_s]
      city_id = City.name_to_id(address["city"])
      # Entering that into the address city_id
      address[:city_id] = city_id
    end
  end

  def whitelisted_params
    # Hopefully i can just require and permit this now...
    params.require(:user).permit(:billing_id, :shipping_id, :email, :first_name, :last_name, :addresses_attributes => [:id, :street_address, :state_id, :zip_code, :city_id])
  end

end
