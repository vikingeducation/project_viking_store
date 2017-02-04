module AddressesHelper
	def addresses_params
    	params.require(:address).permit(:street_address, :secondary_address, :zip_code, :city_id, :state_id, :user_id)
  	end
end
