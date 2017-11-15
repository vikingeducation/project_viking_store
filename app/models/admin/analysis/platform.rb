module Admin
  module Analysis
    class Platform
      def self.from(*times)
        result = times.flatten.map { |time| new(from_day: time) }
        result.one? ? result.first : result
      end

      def initialize(from_day: Time.at(0))
        @from_day = from_day
      end

      def number_of_users
        User.from(@from_day).count
      end

      def number_of_orders
        Order.checkout_from(@from_day).count
      end

      def number_of_products
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
