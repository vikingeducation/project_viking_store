class Product < ApplicationRecord

	validates 	:name, :description, :price, :category_id, :presence => true

    validates	:price, numericality: { less_than_or_equal_to: 10000 }, :format => { :without => /\$/ }

    validates 	:category_id, :inclusion => Category.select("categories.id").to_a.collect {|category| category.id }

	def self.past_days(n)
		Product.where(:created_at => (Time.now - n.days)..Time.now)
	end
end
