class OrderContent < ActiveRecord::Base

  def self.get_revenue(time = nil)
    
    result = OrderContent.select("SUM(quantity * price) AS revenue_sum")
                          .joins("JOIN products ON order_contents.product_id = products.id")                          
                          .joins("JOIN orders ON order_contents.order_id = orders.id")
                          .where("checkout_date IS NOT NULL") 
    if time != nil
      days_ago = time.days.ago
      result = result.where("checkout_date > ?", days_ago)
    end
    "$" + result.to_a.first.revenue_sum.to_f.to_s
  end

  def self.get_revenue_by_day(time = nil)
    result = OrderContent.select("SUM(quantity * price) AS revenue_sum")
                          .joins("JOIN products ON order_contents.product_id = products.id")                          
                          .joins("JOIN orders ON order_contents.order_id = orders.id")
                          .where("checkout_date IS NOT NULL") 
    if time != nil
      days_ago = time.days.ago
      result = result.where("checkout_date > ?", days_ago)
    end
    "$" + result.to_a.first.revenue_sum.to_f.to_s
  end

  def self.get_average_order(time = nil)
    result = OrderContent.select("ROUND(AVG(quantity * price), 2) AS average_order")
                            .joins("JOIN products ON order_contents.product_id = products.id")                          
                            .joins("JOIN orders ON order_contents.order_id = orders.id")
                            .where("checkout_date IS NOT NULL") 
    if time != nil
      days_ago = time.days.ago
      result = result.where("checkout_date > ?", days_ago)
    end
    "$" + result.to_a.first.average_order.to_f.to_s
  end

    def self.get_largest_order(time = nil)
      result = OrderContent.select("MAX(quantity * price) AS max_order")
                            .joins("JOIN products ON order_contents.product_id = products.id")                          
                            .joins("JOIN orders ON order_contents.order_id = orders.id")
                            .where("checkout_date IS NOT NULL") 
    if time != nil
      days_ago = time.days.ago
      result = result.where("checkout_date > ?", days_ago)
    end
    "$" + result.to_a.first.max_order.to_f.to_s

    end

  
end

  # # result = OrderContent.find_by_sql(
    # #       "SELECT SUM(quantity * price)
    #       FROM order_contents
    #       JOIN products ON order_contents.product_id = products.id
    #       JOIN orders ON order_contents.order_id = orders.id
    #       WHERE checkout_date IS NOT NULL
    #       ") 
    # result.first.sum.to_f