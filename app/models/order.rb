class Order < ActiveRecord::Base
  scope :last_seven_days, -> { get_created_at(7.days.ago) }
  scope :last_thirty_days, -> { get_created_at(30.days.ago) }
  scope :revenue_last_seven_days, -> { get_revenue(7.days.ago) }
  scope :revenue_last_thirty_days, -> { get_revenue(30.days.ago) }

  class << self

    private
      def get_created_at(time)
        where("created_at <= ?", time).count
      end


      def get_revenue(time)
        Order.find_by_sql(["SELECT SUM(order_contents.quantity * products.price) as total_revenue FROM orders JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id WHERE orders.checkout_date IS NOT NULL AND order_contents.created_at <= ?", 7.days.ago]).first.total_revenue.to_i
      end

  end

end
