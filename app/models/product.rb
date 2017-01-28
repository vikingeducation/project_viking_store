class Product < ApplicationRecord
	def self.past_days(n)
		Product.where(:created_at => (Time.now - n.days)..Time.now)
	end
end
