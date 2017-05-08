class DashboardController < ApplicationController

  def index

    @one = {
      :total => one_total,
      :thirty_days => one_thirty_days,
      :seven_days => one_seven_days
    }

    @two = {
      :states => top_3_states_users_live,
      :cities => top_3_cities_users_live,
      :top_user_with => top_user_with
    }

    @three = {
      :total => three_total,
      :thirty_days => three_thirty_days,
      :seven_days => three_seven_days
    }
  end

  # ------------------------------------------------------------
  # Helpers
  # ------------------------------------------------------------

  def total_revenue
    OrderContent.joins(
      "JOIN orders ON orders.id = order_contents.order_id").joins(
      "JOIN products ON products.id = order_contents.product_id").where(
      "orders.checkout_date IS NOT NULL").sum(
      "products.price * order_contents.quantity")
  end

  def revenue_since(d)
    OrderContent.joins(
      "JOIN orders ON orders.id = order_contents.order_id").joins(
      "JOIN products ON products.id = order_contents.product_id").where(
      "orders.checkout_date IS NOT NULL AND order_contents.created_at > ?", d).sum(
      "products.price * order_contents.quantity")
  end

  def one_total
    [
      {:column_name => "New Users", :data => User.count},
      {:column_name => "Orders", :data => Order.count},
      {:column_name => "New Products", :data => Product.count},
      {:column_name => "Revenue", :data => total_revenue}
    ]
  end

  def one_seven_days
    [
      {:column_name => "New Users",
       :data => User.where("created_at > ?", Time.now - 7.minute).count},
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 7.day).count},
      {:column_name => "New Products",
       :data => Product.where("created_at > ?", Time.now - 7.day).count},
      {:column_name => "Revenue",
       :data => revenue_since(Time.now - 7.day)}
    ]
  end

  def one_thirty_days
    [
      {:column_name => "New Users",
       :data => User.where("created_at > ?", Time.now - 30.day).count},
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 30.day).count},
      {:column_name => "New Products",
       :data => Product.where("created_at > ?", Time.now - 30.day).count},
      {:column_name => "Revenue",
       :data => revenue_since(Time.now - 30.day)}
    ]
  end

  def top_3_states_users_live
    State.select(
      "states.name, COUNT(states.name) AS total"
    ).joins(
      "JOIN addresses a ON a.state_id = states.id"
    ).joins(
      "JOIN users u ON u.billing_id = a.id"
    ).group("states.name").order("total DESC").limit(3)
  end

  def top_3_cities_users_live
    City.select(
      "cities.name, COUNT(cities.name) AS total"
    ).joins(
      "JOIN addresses a ON a.city_id = cities.id"
    ).joins(
      "JOIN users u ON u.billing_id = a.id"
    ).group(:name).order("total DESC").limit(3)
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
    {:column_name => "Highest Single Order Value",
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
    {:column_name => "Most Orders Placed",
     :customer_name => r.customer_name,
     :quantity => r.quantity}
  end

  def top_user_with
    [
      highest_order_value,
      highest_lifetime_value,
      highest_average_order_value,
      most_orders_placed
    ]
  end

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

  def three_total
    [
      {:column_name => "Orders", :data => Order.count},
      {:column_name => "Revenue", :data => total_revenue},
      {:column_name => "Average Order Value", :data => average_order_value.to_i},
      {:column_name => "Largest Order Value", :data => highest_order_value[:quantity]}
    ]
  end

  def three_thirty_days
    [
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 30.day).count},
      {:column_name => "Revenue", :data => revenue_since(Time.now - 30.day)},
      {:column_name => "Average Order Value",
       :data => avg_order_value_since(Time.now - 30.day).to_i},
      {:column_name => "Largest Order Value",
       :data => highest_order_value_since(Time.now - 30.day)[:quantity]}
    ]
  end

  def three_seven_days
    [
      {:column_name => "Orders",
       :data => Order.where("created_at > ?", Time.now - 7.day).count},
      {:column_name => "Revenue",
       :data => revenue_since(Time.now - 7.day)},
      {:column_name => "Average Order Value",
       :data => avg_order_value_since(Time.now - 7.day).to_i},
      {:column_name => "Largest Order Value",
       :data => highest_order_value_since(Time.now - 7.day)[:quantity]}
    ]
  end


end
