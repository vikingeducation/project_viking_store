class Product < ApplicationRecord
  scope :listed_since, ->(begin_date) {
    where('created_at > ? AND created_at < ?', begin_date, Time.zone.now)
  }

  def self.listed_in_last(num_days)
    begin_date = eval("#{num_days}.days.ago")
    listed_since(begin_date)
  end

  def self.revenue
    joins('JOIN order_contents ON products.id = order_contents.product_id')
      .joins('JOIN orders ON order_contents.order_id = orders.id')
      .sum('products.price * order_contents.quantity')
      .to_f
  end
end
