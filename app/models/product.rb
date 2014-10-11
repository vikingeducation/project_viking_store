class Product < ActiveRecord::Base

  has_many :order_contents
  has_many :orders, through: :order_contents

  belongs_to :category

	def self.products(time)
		Product.where('created_at > ?',time).count
	end

end
