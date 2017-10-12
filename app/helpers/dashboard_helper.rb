module DashboardHelper


  FIRST_ORDER_DATE = Order.select(:created_at).first
  REVENUE = 'order_contents.quantity * products.price'
  SEVEN_DAYS = 7.days.ago
  THIRTY_DAYS = 30.days.ago



  def overall_count(model, num_days_ago)
    model.where('created_at >= ?', num_days_ago).count
  end


  def join_orders_onto_addresses
    joins('JOIN orders ON orders.billing_id = addresses.id')
  end


  def join_products_onto_ordercontents
    joins('JOIN products ON products.id = order_contents.product_id')
  end


  def join_ordercontents_onto_orders
    joins('JOIN order_contents ON orders.id = order_contents.order_id')
  end


  def group_top_three(place_name)
    group(place_name).order('count(*) DESC').limit(3).count
  end


  def map_value_to_float
    map{|k,v| [k, v.to_f] }
  end



end
