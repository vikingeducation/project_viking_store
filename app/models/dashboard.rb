class Dashboard
  attr_reader :overall_platform, :user_demographics,
              :order_statistics, :time_series_data

  def initialize
    @overall_platform  = populate_overall_platform
    @user_demographics = populate_user_demographics
    @order_statistics  = populate_order_statistics
    @time_series_data  = populate_time_series_data
  end

private

    def populate_overall_platform
      op = Hash.new { |h, k| h[k] = { } }

      op[:last_7_days][:title] = "Last 7 Days"
      op[:last_7_days][:data] = { new_users: User.get_new_user_count(7),
                                  orders: Order.get_order_count(7),
                                  new_products: Product.get_product_count(7),
                                  revenue: get_revenue(7) }

      op[:last_30_days][:title] = "Last 30 Days"
      op[:last_30_days][:data]  = { new_users: User.get_new_user_count(30),
                                    orders: Order.get_order_count(30),
                                    new_products: Product.get_product_count(30),
                                    revenue: get_revenue(30) }

      op[:totals][:title] = "Totals"
      op[:totals][:data]  = { new_users: User.get_new_user_count,
                              orders: Order.get_order_count,
                              new_products: Product.get_product_count,
                              revenue: get_revenue }

      op
    end

    def populate_user_demographics
      ud = Hash.new { |h, k| h[k] = { } }

      ud[:top_3_states][:title] = "Top 3 States Users Live In (billing)"
      ud[:top_3_states][:data]  = { states: get_top_states }

      ud[:top_3_cities][:title] = "Top 3 Cities Users Live In (billing)"
      ud[:top_3_cities][:data]  = { cities: get_top_cities }

      ud[:top_user_with][:title] = "Top User With"
      ud[:top_user_with][:data] = {
                         highest_single_order: highest_single_order
                       }
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

    def get_top_states
      User.select("states.name, COUNT(*) AS state_count")
          .joins(" JOIN addresses ON billing_id=addresses.id
                   JOIN states ON state_id=states.id")
                   .group("states.name")
                   .order("state_count DESC")
                   .limit(3)
    end

    def get_top_cities
      User.select("cities.name, COUNT(*) AS city_count")
          .joins(" JOIN addresses ON billing_id=addresses.id
                   JOIN cities ON city_id=cities.id")
                   .group("cities.name")
                   .order("city_count DESC")
                   .limit(3)
    end

    def highest_single_order
      hso = User.select("first_name, last_name,
                         SUM(quantity * price) AS total_price")
                         .join_orders_products
                         .where("checkout_date IS NOT NULL")
                         .group("first_name, last_name, order_id")
                         .order("total_price DESC")
                         .limit(1)
      ["Highest Single Order Value", "#{hso.first_name} #{hso.last_name}", hso.first.total_price.to_f]
    end


end
