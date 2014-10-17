module ProductsHelper
	def checked_out(arg)
		@product.orders.where(checked_out: arg).count
	end
end
