class Product < ActiveRecord::Base

	def self.total_products(date=nil)
		p = Product.all

		unless date.nil?
			p.where("created_at > ?", date).count
		else
			p.count
		end
	end
end
