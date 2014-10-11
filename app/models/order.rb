class Order < ActiveRecord::Base

  belongs_to :user

  has_many :order_contents
  has_many :products, through: :order_contents


	def self.orders(time)
		Order.where('is_placed = ? AND placed_at > ?',true,time).count
	end
end
