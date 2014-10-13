class Order < ActiveRecord::Base

  belongs_to :user

  has_many :order_contents
  has_many :products, through: :order_contents

  before_save :add_timestamp

	def self.orders(time)
		Order.where('is_placed = ? AND placed_at > ?',true,time).count
	end

  def add_timestamp
    if self.is_placed 
      self.placed_at = Date.today
    end
  end
end
