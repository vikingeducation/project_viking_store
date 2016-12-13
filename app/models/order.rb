class Order < ApplicationRecord
  belongs_to :address
  belongs_to :user
  belongs_to :credit_card
  has_many :order_contents
  has_many :products, through: :order_contents

  def self.total_orders(day_number = nil)
    day_number.nil? ? Order.all.count : Order.all.where(created_at: day_number.days.ago.beginning_of_day..Time.now).count
  end

  def self.total_revenue(day_number = nil)
    if day_number.nil?
      Order.joins(:order_contents,:products)
          .where("orders.checkout_date is not null")
          .sum("order_contents.quantity * products.price").to_f
    else
      Order.where(created_at: day_number.days.ago.beginning_of_day..Time.now)
          .joins(:order_contents,:products)
          .where("orders.checkout_date is not null")
          .sum("order_contents.quantity * products.price").to_f
    end
  end
end
