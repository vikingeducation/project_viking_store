module ShopHelper

	def find_product(products, product_id, quantity)
		if quantity > 1
			"#{products.find(product_id).name}s"
		else
			"#{products.find(product_id).name}"
		end
	end

end
