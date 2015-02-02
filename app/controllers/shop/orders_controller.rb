class Shop::OrdersController < ApplicationController

	# def add_item
	# 	@product_id = params[:id].to_s
	# 	# check if there is a cart in cookies
	# 	if cookies[:cart]

	# 		# parse that cart into a hash
	# 		@cart = JSON.parse(cookies[:cart])

	# 		# check if product id is in @cart hash
	# 		# add to quantity if it is. Set to 1 if not
	# 		if @cart.has_key?(@product_id)
	# 			@cart[@product_id] += 1
	# 			fail
	# 		else

	# 			@cart[@product_id] = 1
	# 		end

	# 			# convert hash back to json and save to cookies
	# 			cookies[:cart] = @cart.to_json

	# 	else
	# 		# create cart if there is not one by serializing a hash
	# 		cookies[:cart] = {@product_id => 1}.to_json
	# 	end
	# 	fail
	# 	redirect_to shop_products_path
	# end

	def add_item
		@product_id = params[:id]
		@cart = session[:cart]
		# check if there is a cart in cookies
		if @cart
			# check if product id is in @cart hash
			# add to quantity if it is. Set to 1 if not
			if @cart.has_key?(@product_id)
				@cart[@product_id] += 1
			else
				@cart[@product_id] = 1
			end
		else
			# create cart if there is not one by serializing a hash
			session[:cart][@product_id] = 1
		end
		fail
		redirect_to shop_products_path
	end


end
