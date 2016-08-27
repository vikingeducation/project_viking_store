class OrderContent < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, numericality: { only_integer: true }

  def self.all_product_sold
    OrderContent.joins("
    JOIN orders ON order_id = orders.id").joins("
    JOIN products on product_id = products.id").where("
    checkout_date IS NOT null")
  end

  def self.new_revenue_7
    all_product_sold.where("
    checkout_date > '#{Time.now.to_date - 7}'").sum("
    price * quantity")
  end

  def self.new_revenue_30
    all_product_sold.where("
    checkout_date > '#{Time.now.to_date - 30}'").sum("
    price * quantity")
  end

  def self.total_revenue
    all_product_sold.sum("price * quantity")
  end

end
