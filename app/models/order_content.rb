class OrderContent < ApplicationRecord

  FIRST_ORDER_DATE = Order.select(:created_at).first

  belongs_to :order
  belongs_to :product

  validates :quantity, :product_id, presence: true

  validates_numericality_of :quantity, :product_id, greater_than: 0

  def self.revenue_statistics
    revenue_hash = {}
      revenue_hash[:sevendays] = revenue_for(7.days.ago)
      revenue_hash[:thirtydays] = revenue_for(30.days.ago)
      revenue_hash[:total] = revenue_for(FIRST_ORDER_DATE.created_at)
    revenue_hash
  end


  private


  def self.revenue_for(num_days_ago)
    OrderContent.joins(:product)
                .where('order_contents.created_at >= ?', num_days_ago)
                .sum('order_contents.quantity * products.price')
                .round
  end


end
