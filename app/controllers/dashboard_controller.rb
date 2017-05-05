class DashboardController < ApplicationController

  def index

    seven_days = {
      :users => User.where("created_at > ?", Time.now - 7.minute).count,
      :orders => Order.where("created_at > ?", Time.now - 7.day).count,
      :products => Product.where("created_at > ?", Time.now - 7.day).count,
      :revenue => revenue_since(Time.now - 7.day)
    }

    thirty_days = {
      :users => User.where("created_at > ?", Time.now - 30.day).count,
      :orders => Order.where("created_at > ?", Time.now - 30.day).count,
      :products => Product.where("created_at > ?", Time.now - 30.day).count,
      :revenue => revenue_since(Time.now - 30.day)
    }

    total = {
      :users => User.count,
      :orders => Order.count,
      :products => Product.count,
      :revenue => total_revenue
    }

    @one = {
      :total => total,
      :thirty_days => thirty_days,
      :seven_days => seven_days
    }
  end

  # Helpers

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

end
