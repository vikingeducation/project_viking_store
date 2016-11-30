class Dashboard
  attr_reader :overall_platform, :user_demographics,
              :order_statistics, :time_series_data

  def initialize
    @overall_platform  = populate_overall_platform
    @user_demographics = populate_user_demographics
    @order_statistics  = populate_order_statistics
    @time_series_data  = populate_time_series_data
  end

  def populate_overall_platform
    op = Hash.new { |h, k| h[k] = { } }

    op[:last_7][:new_users] = User.get_new_user_count(7)
    op[:last_7][:orders] = Order.get_order_count(7)
    op[:last_7][:new_products] = Product.get_product_count(7)
    op[:last_7][:revenue] = get_revenue(7)

    op[:last_30][:new_users] = User.get_new_user_count(30)
    op[:last_30][:orders] = Order.get_order_count(30)
    op[:last_30][:new_products] = Product.get_product_count(30)
    op[:last_30][:revenue] = get_revenue(30)

    op[:totals][:new_users] = User.get_new_user_count
    op[:totals][:orders] = Order.get_order_count
    op[:totals][:new_products] = Product.get_product_count
    op[:totals][:revenue] = get_revenue

    op
  end

  def populate_user_demographics
    {}
  end

  def populate_order_statistics
    {}
  end

  def populate_time_series_data
    {}
  end

  def get_revenue(n_of_days = nil)
    return total_revenue unless n_of_days

    Order.joins("JOIN order_contents ON orders.id=order_id
                 JOIN products ON products.id=product_id")
                 .where("checkout_date > NOW() - INTERVAL '? days'", n_of_days)
                 .sum("quantity * price")
  end

  def total_revenue
    Order.joins(" JOIN order_contents ON orders.id=order_id
                  JOIN products ON products.id=product_id")
                  .where("checkout_date IS NOT NULL")
                  .sum("quantity * price ")
  end
end
