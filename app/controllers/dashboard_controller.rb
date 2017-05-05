class DashboardController < ApplicationController

  def index

    @one = {
      :total => one_total,
      :thirty_days => one_thirty_days,
      :seven_days => one_seven_days
    }

    @two = {
      :states => top_3_states_users_live,
      :cities => top_3_cities_users_live
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
    {
      :users => User.count,
      :orders => Order.count,
      :products => Product.count,
      :revenue => total_revenue
    }
  end

  def one_seven_days
    {
      :users => User.where("created_at > ?", Time.now - 7.minute).count,
      :orders => Order.where("created_at > ?", Time.now - 7.day).count,
      :products => Product.where("created_at > ?", Time.now - 7.day).count,
      :revenue => revenue_since(Time.now - 7.day)
    }
  end

  def one_thirty_days
    {
      :users => User.where("created_at > ?", Time.now - 30.day).count,
      :orders => Order.where("created_at > ?", Time.now - 30.day).count,
      :products => Product.where("created_at > ?", Time.now - 30.day).count,
      :revenue => revenue_since(Time.now - 30.day)
    }
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


end
