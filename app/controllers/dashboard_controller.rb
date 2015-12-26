class DashboardController < ApplicationController
  def index
    # Panel 1: Overall Platform
    @overall_7_days = get_overall_stats(7)
    @overall_30_days = get_overall_stats(730)
    @overall_total = get_overall_stats

    # Panel 2: User Demographics and Behavior
    @top_states = User.select("s.name, COUNT(*) as count").joins(user_state_join).group("s.id").order("count DESC").limit(3)
    @top_cities = User.select("c.name, COUNT(*) as count").joins(user_city_join).group("c.id").order("count DESC").limit(3)
  end

  private

  def get_overall_stats(days_ago = nil)
    if days_ago
      {
        num_users: User.days_ago(days_ago).count,
        num_orders: Order.days_ago(days_ago).count,
        num_products: Product.days_ago(days_ago).count,
        total_revenue: get_revenue(days_ago)
      }
    else
      {
        num_users: User.all.count,
        num_orders: Order.all.count,
        num_products: Product.all.count,
        total_revenue: get_revenue
      }
    end
  end

  def get_revenue(days_ago = nil)
    select_revenue = "SUM(p.price * oc.quantity) as revenue"
    if days_ago
      relation = Order.select(select_revenue).joins(order_product_join).days_ago(days_ago)
    else
      relation = Order.select(select_revenue).joins(order_product_join)
    end
    relation[0].revenue
  end

  def order_product_join
    "JOIN order_contents oc ON oc.order_id = orders.id JOIN products p ON p.id = oc.product_id"
  end

  def user_state_join
    "JOIN addresses a ON a.id = users.billing_id JOIN states s ON s.id = a.state_id"
  end

  def user_city_join
    "JOIN addresses a ON a.id = users.billing_id JOIN cities c ON c.id = a.city_id"
  end
end
