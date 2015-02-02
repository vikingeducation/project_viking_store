class ShopController < ApplicationController
	layout 'application'

	def index

		redirect_to shop_products_path
	end

end

