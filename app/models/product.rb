class Product < ApplicationRecord

	belongs_to :category
	has_many :order_contents
	has_many :orders, 
			 :through => :order_contents

	validates 	:name, :description, :price, :category_id, :presence => true

    validates	:price, numericality: { less_than_or_equal_to: 10000 }, :format => { :without => /\$/ }

    #validates 	:category_id, :inclusion => { in: Category.pluck(:id)}

	def self.past_days(n)
		Product.where(:created_at => (Time.now - n.days)..Time.now)
	end
end
