class Order < ActiveRecord::Base
  scope :last_seven_days, -> { get_created_at(7.days.ago) }
  scope :last_thirty_days, -> { get_created_at(30.days.ago) }
  scope :revenue_last_seven_days, -> { get_revenue(7.days.ago) }
  scope :revenue_last_thirty_days, -> { get_revenue(30.days.ago) }
  scope :average_last_seven_days, -> { get_average_value(7.days.ago) }
  scope :average_last_thirty_days, -> { get_average_value(30.days.ago) }
  scope :largest_last_seven_days, -> { get_largest_revenue(7.days.ago) }
  scope :largest_last_thirty_days, -> { get_largest_revenue(30.days.ago) }

  class << self

    private
      def get_created_at(time)
        where("created_at >= ?", time).count
      end


      def get_revenue(time)
        Order.joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id")
             .where("orders.checkout_date IS NOT NULL AND orders.checkout_date >= ?", time)
             .sum("order_contents.quantity * products.price")
      end

      # def get_average_value(time)
      #   Order.joins("JOIN order_contents ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id")
      #        .where("orders.checkout_date IS NOT NULL AND orders.checkout_date >= ?", time)
      #        .group("orders.id")
      #        .select("(order_contents.quantity * products.price) AS revenue")
      #        .average("revenue")
      # end

      def get_largest_revenue(time)
        OrderContent.select("(order_contents.quantity * products.price) AS order_value")
                    .joins("JOIN orders ON orders.id = order_contents.order_id JOIN products ON order_contents.product_id = products.id JOIN users ON users.id = orders.user_id")
                    .where("orders.checkout_date IS NOT NULL AND orders.checkout_date >= ?",time)
                    .group("users.id, order_contents.quantity, products.price")
                    .order("order_value DESC")
                    .limit(1)
                    .first
                    .order_value
      end

  end

end
