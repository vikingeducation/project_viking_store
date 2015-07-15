class Order < ActiveRecord::Base

  def self.count_orders(day_range = nil)
    if day_range.nil?
      Order.where("checkout_date IS NOT NULL").count
    else
      Order.where("checkout_date > ?", Time.now - day_range.days).count
    end
  end



  # for all new orders within past x days
  def self.calc_revenue(day_range = nil)
    if day_range.nil?
      Order.joins("JOIN order_contents ON orders.id = order_contents.order_id
                 JOIN products ON order_contents.product_id = products.id").
            where("orders.checkout_date IS NOT NULL").
            sum("products.price * order_contents.quantity")
    else
      Order.joins("JOIN order_contents ON orders.id = order_contents.order_id
                   JOIN products ON order_contents.product_id = products.id").
            where("orders.checkout_date > ?", Time.now - day_range.days).
            sum("products.price * order_contents.quantity")
    end
  end


  def self.order_stats_by_day_range(day_range = nil)
    # all days

    base_query = Order.select("COUNT(DISTINCT orders.id) AS count,
                                SUM(products.price * order_contents.quantity) AS revenue,
                                MAX(products.price * order_contents.quantity) AS maximum").
                        joins("JOIN order_contents ON orders.id = order_contents.order_id
                              JOIN products ON order_contents.product_id = products.id")

    if day_range.nil?
      full_query = base_query.where("orders.checkout_date IS NOT NULL").first
    else
      full_query = base_query.where("orders.checkout_date > ?", Time.now - day_range.days).first
    end


    table_data = {'Number of Orders' => full_query.count,
                  'Total Revenue' => full_query.revenue,
                  'Average Order Value' => full_query.revenue / full_query.count,
                  'Largest Order Value' => full_query.maximum
                  }

    table_data

  end



  private



end
