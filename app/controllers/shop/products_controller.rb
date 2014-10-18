class Shop::ProductsController < ShopController

	def index
		if params[:category]
			@products = Product.where(category_id: params[:category][:id])
		else
			@products = Product.all
		end
	end

	def cart_params
		params.require(:product).permit(:id)
	end

end

# Dunno where to put:
#     @order = Order.find(params[:id])
#     @user = @order.user


		# if @order.exist?(params[:id])
		# 	@order = Order.find(params[:id])
		# else
		# 	@order = Order.create(cart_params)
		# end


