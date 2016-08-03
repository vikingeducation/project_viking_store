class Order < ActiveRecord::Base
  scope :last_seven_days, -> { get_created_at(7.days.ago) }
  scope :last_thirty_days, -> { get_created_at(30.days.ago) }
  scope :revenue_last_seven_days, -> { get_revenue(7.days.ago) }
  scope :revenue_last_thirty_days, -> { get_revenue(30.days.ago) }

  class << self

    private
      def get_created_at(time)
        where("created_at >= ?", time).count
      end


      def get_revenue(time)
        Order.joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = product_id").where("orders.checkout_date IS NOT NULL AND orders.checkout_date >= ?", time).sum("order_contents.quantity * products.price")
      end

  end

end
