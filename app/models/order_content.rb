class OrderContent < ActiveRecord::Base

  def self.get_revenue
    joins('JOIN products ON (order_contents.product_id = products.id)')
  end

  def self.day_revenue(day)
      get_revenue.joins('JOIN orders ON (order_contents.order_id = orders.id)')
                .where("checkout_date > ? ", day.days.ago).sum('products.price * order_contents.quantity')
  end


  def self.total_revenue
    get_revenue.sum('products.price * order_contents.quantity')
  end

end
