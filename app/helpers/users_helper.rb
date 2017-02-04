module UsersHelper
	def users_params
    	params.require(:user).permit(:first_name, :last_name, :email, :phone, :billing_id, :shipping_id)
  	end
end
