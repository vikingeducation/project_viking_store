class Product < ActiveRecord::Base

	def self.new_products(input_day)
		self.where("created_at > ?", input_day.days.ago).count
	end
end
