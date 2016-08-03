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
      total_sum = "$" + result.to_a.first.revenue_sum.to_f.to_s
    #   result = OrderContent.select("SUM(quantity * price) AS revenue_sum")
    #                         .joins("JOIN products ON order_contents.product_id = products.id")                          
    #                         .joins("JOIN orders ON order_contents.order_id = orders.id")
    #                         .where("checkout_date IS NOT NULL AND checkout_date > ?", days_ago")
                            
    #   return result.to_a.first.revenue_sum.to_f

    # # result = OrderContent.find_by_sql(
    # #       "SELECT SUM(quantity * price)
    #       FROM order_contents
    #       JOIN products ON order_contents.product_id = products.id
    #       JOIN orders ON order_contents.order_id = orders.id
    #       WHERE checkout_date IS NOT NULL
    #       ") 
    # result.first.sum.to_f
  end

  
end
