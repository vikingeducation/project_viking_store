class Admin::Analysis::OrderTimeSeries
  include Virtus.model

  attribute :date, Date
  attribute :quantity, Integer, :default => 0
  attribute :value, Decimal, :default => 0

  def self.orders_by_day
    query do
      <<~SQL
        SELECT DATE(days) AS date, count(orders.id) AS quantity, COALESCE(SUM(products.price * order_contents.quantity), 0) AS value
        FROM GENERATE_SERIES((CURRENT_DATE - 6), CURRENT_DATE, '1 DAY'::INTERVAL) AS days
        LEFT JOIN orders ON DATE(orders.checkout_date) = days
        LEFT JOIN order_contents ON orders.id = order_contents.order_id
        LEFT JOIN products ON products.id = order_contents.product_id
        GROUP BY days
        ORDER BY days DESC
      SQL
    end
  end

  def self.orders_by_week
    query do
      <<~SQL
        SELECT DATE(weeks) AS date, count(orders.id) AS quantity, COALESCE(SUM(products.price * order_contents.quantity), 0) AS value
        FROM GENERATE_SERIES((SELECT DATE(DATE_TRUNC('WEEK', MIN(checkout_date))) FROM orders),
          CURRENT_DATE, '1 WEEK'::INTERVAL) AS weeks
        LEFT JOIN orders ON DATE(orders.checkout_date) = weeks
        LEFT JOIN order_contents ON orders.id = order_contents.order_id
        LEFT JOIN products ON products.id = order_contents.product_id
        GROUP BY weeks
        ORDER BY weeks DESC
        LIMIT 7
      SQL
    end
  end

  def self.query(&block)
    Result.new ActiveRecord::Base.connection.exec_query(yield)
  end
  
  class Result
    def initialize(result)
      @result = result
    end

    delegate :each, to: :to_a

    private

    def to_a
      @result.to_hash.map do |h|
        Admin::Analysis::OrderTimeSeries.new(h)
      end
    end
  end
end
