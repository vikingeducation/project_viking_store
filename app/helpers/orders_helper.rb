module OrdersHelper
	def orders_params
    	params.require(:order).permit(:checkout_date, :user_id, :shipping_id, :billing_id)
  	end
end
