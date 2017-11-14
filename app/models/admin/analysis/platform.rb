module Admin
  module Analysis
    class Platform
      def initialize(from_day: Time.at(0))
        @from_day = from_day
      end

      def users_count
        User.from(@from_day).count
      end

      def orders_count
        Order.checkout_from(@from_day).count
      end

      def products_count
        Product.from(@from_day).count
      end

      def revenue
        Order.checkout_from(@from_day).total_revenue
      end

      def number_of_days
        @number_of_days ||= ((@from_day.midnight - 1.day.ago).to_i / 1.day).abs
      end
    end
  end
end
