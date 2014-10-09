class Purchase < ActiveRecord::Base

  belongs_to :order
  belongs_to :product

  validates :product_id, uniqueness: { scope: :order_id }

  def self.revenue(last_x_days = nil)

    if last_x_days
      joins("JOIN products ON purchases.product_id = products.id JOIN orders ON orders.id = purchases.order_id").
      where("orders.checkout_date > ?", Time.now - last_x_days.days).
      sum("(purchases.quantity * products.price)")
    else
      joins("JOIN products ON purchases.product_id = products.id JOIN orders ON orders.id = purchases.order_id").
      sum("(purchases.quantity * products.price)")
    end

  end
end