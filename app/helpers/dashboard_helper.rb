module DashboardHelper
  def average_order_value
    r = Order.joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("orders.checkout_date IS NOT NULL").average("p.price")
  end

  def avg_order_value_since(d)
    r = Order.joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where(
      "orders.checkout_date IS NOT NULL AND oc.created_at > ?", d
    ).average("p.price")
  end


  def highest_average_order_value
    r = Order.select(
      "AVG(p.price) AS quantity, u.first_name || ' ' || u.last_name AS customer_name"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group(:customer_name).order(
      "1 DESC"
    ).limit(1).first
    {:column_name => "Highest Average Order Value",
     :customer_name => r.customer_name,
     :quantity => r.quantity}
  end

  def highest_lifetime_value
    r = Order.select(
      "SUM(p.price) AS quantity, u.first_name || ' ' || u.last_name AS customer_name"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group(:customer_name).order(
      "1 DESC"
    ).limit(1).first
    {:column_name => "Highest Lifetime Value",
     :customer_name => r.customer_name,
     :quantity => r.quantity}
  end

  def highest_order_value
    r = Order.select(
      "SUM(p.price) AS quantity,
       u.first_name || ' ' || u.last_name AS customer_name,
       orders.id AS order_id"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group("2, 3").order(
      "1 DESC"
    ).limit(1).first
  end

  def highest_order_value_since(d)
    r = Order.select(
      "SUM(p.price) AS quantity,
       u.first_name || ' ' || u.last_name AS customer_name,
       orders.id AS order_id"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where(
      "checkout_date IS NOT NULL AND oc.created_at > ?", d
    ).group("2, 3").order(
      "1 DESC"
    ).limit(1).first
    if r
      {:customer_name => r.customer_name,
       :quantity => r.quantity}
    else
      {:customer_name => "No result",
       :quantity => 0}
    end
  end


  def most_orders_placed
    r = Order.select(
      "COUNT(orders.user_id) AS quantity,
       u.first_name || ' ' || u.last_name AS customer_name"
    ).joins(
      "JOIN users u ON u.id = orders.user_id"
    ).joins(
      "JOIN order_contents oc ON oc.order_id = orders.id"
    ).joins(
      "JOIN products p ON oc.product_id = p.id"
    ).where("checkout_date IS NOT NULL").group(:customer_name).order(
      "1 DESC"
    ).limit(1).first
  end

  def revenue_since(d)
    OrderContent.joins(
      "JOIN orders ON orders.id = order_contents.order_id").joins(
      "JOIN products ON products.id = order_contents.product_id").where(
      "orders.checkout_date IS NOT NULL AND order_contents.created_at > ?", d).sum(
      "products.price * order_contents.quantity")
  end

  def top_3_cities_users_live
    City.select(
      "cities.name, COUNT(cities.name) AS quantity"
    ).joins(
      "JOIN addresses a ON a.city_id = cities.id"
    ).joins(
      "JOIN users u ON u.billing_id = a.id"
    ).group(:name).order("1 DESC").limit(3)
  end

  def top_3_states_users_live
    State.select(
      "states.name, COUNT(states.name) AS quantity"
    ).joins(
      "JOIN addresses a ON a.state_id = states.id"
    ).joins(
      "JOIN users u ON u.billing_id = a.id"
    ).group("states.name").order("1 DESC").limit(3)
  end

  def total_revenue
    OrderContent.joins(
      "JOIN orders ON orders.id = order_contents.order_id").joins(
      "JOIN products ON products.id = order_contents.product_id").where(
      "orders.checkout_date IS NOT NULL").sum(
      "products.price * order_contents.quantity")
  end


end
