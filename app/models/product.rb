class Product < ActiveRecord::Base
	def self.total_product
		# Allow us to pass in a block which will get the rows in a 
		# particular timeframe.
		if block_given?
			in_timeframe = yield
			in_timeframe.count
		else
			Product.count
		end
	end
end
