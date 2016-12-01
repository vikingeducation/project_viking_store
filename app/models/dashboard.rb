class Dashboard
  attr_reader :overall_platform, :user_demographics,
              :order_statistics, :time_series_data

  def initialize
    @overall_platform  = populate_overall_platform
    @user_demographics = populate_user_demographics
    @order_statistics  = populate_order_statistics
    @time_series_data  = populate_time_series_data
  end

# private

    def populate_overall_platform
      op = {}

      op[:last_7_days]= { title: "Last 7 Days",
                          data: { new_users: User.get_new_user_count(7),
                                  orders: Order.get_order_count(7),
                                  new_products: Product.get_product_count(7),
                                  revenue: get_revenue(7) }
                        }

      op[:last_30_days]= { title: "Last 30 Days",
                           data: { new_users: User.get_new_user_count(30),
                                    orders: Order.get_order_count(30),
                                    new_products: Product.get_product_count(30),
                                    revenue: get_revenue(30) }
                         }

      op[:totals] = {}
      op[:totals][:title] = "Totals"
      op[:totals][:data]  = { new_users: User.get_new_user_count,
                              orders: Order.get_order_count,
                              new_products: Product.get_product_count,
                              revenue: "$#{get_revenue}" }

      op
    end

    def populate_user_demographics
      ud = Hash.new { |h, k| h[k] = {} }

      top_states = get_top_states
      ud[:top_3_states][:title] = "Top 3 States Users Live In (billing)"
      ud[:top_3_states][:data]  = { state1: top_states[0],
                                    state2: top_states[1],
                                    state3: top_states[2]}

      top_cities = get_top_cities
      ud[:top_3_cities][:title] = "Top 3 Cities Users Live In (billing)"
      ud[:top_3_cities][:data]  = { city1: top_cities[0],
                                    city2: top_cities[1],
                                    city3: top_cities[2]}

      ud[:top_user_with][:title] = "Top User With"
      ud[:top_user_with][:data] = {
                         highest_single_order: highest_single_order,
                         highest_lfv: highest_lfv,
                         highest_avg_ov: highest_avg_ov,
                         most_orders_placed: most_orders_placed
                       }
      ud
    end

    def populate_order_statistics
      os = {}

      os[:last_7_days]= { title: "Last 7 Days",
                          data: { number_of_orders: Order.count("checkout_date"),
                                  total_revenue: get_revenue(7),
                                  average_order_value: average_order_value(7),
                                  largest_order_value: get_revenue(7) }
                        }
      os
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
      ts= User.select("states.name, COUNT(*) AS state_count")
          .joins(" JOIN addresses ON billing_id=addresses.id
                   JOIN states ON state_id=states.id")
                   .group("states.name")
                   .order("state_count DESC")
                   .limit(3)

      [
        [ ts[0].name, ts[0].state_count],
        [ ts[1].name, ts[1].state_count],
        [ ts[2].name, ts[2].state_count]
      ]
    end

    def get_top_cities
      tc = User.select("cities.name, COUNT(*) AS city_count")
           .joins(" JOIN addresses ON billing_id=addresses.id
                   JOIN cities ON city_id=cities.id")
                   .group("cities.name")
                   .order("city_count DESC")
                   .limit(3)

       [
         [ tc[0].name, tc[0].city_count],
         [ tc[1].name, tc[1].city_count],
         [ tc[2].name, tc[2].city_count]
       ]
    end

    def highest_single_order
      hso = User.select("first_name, last_name,
                         SUM(quantity * price) AS total_price")
                         .join_orders_products
                         .where("checkout_date IS NOT NULL")
                         .group("first_name, last_name, order_id")
                         .order("total_price DESC")
                         .limit(1)

      ["Highest Single Order Value", "#{hso[0].first_name} #{hso[0].last_name}", "$#{hso.first.total_price.to_f}"]
    end

    def highest_lfv
      hlv = User.select("first_name, last_name,
                         SUM(quantity * price) AS total_price")
                         .join_orders_products
                         .where("checkout_date IS NOT NULL")
                         .group("first_name, last_name")
                         .order("total_price DESC")
                         .limit(1)

      ["Highest Lifetime Value", "#{hlv[0].first_name} #{hlv[0].last_name}", "$#{hlv.first.total_price.to_f}"]
    end

    def highest_avg_ov
      haov = User.select("first_name, last_name,
                         SUM(quantity * price)/COUNT(*) AS avg_price")
                         .join_orders_products
                         .where("checkout_date IS NOT NULL")
                         .group("first_name, last_name")
                         .order("avg_price DESC")
                         .limit(1)

      ["Highest Average Order Value", "#{haov[0].first_name} #{haov[0].last_name}", "$#{haov.first.avg_price.to_f}"]
    end

    def most_orders_placed
      mop = User.select("first_name, last_name,
                         COUNT(*) AS total_orders")
                         .joins("JOIN orders ON user_id=users.id")
                         .where("checkout_date IS NOT NULL")
                         .group("first_name, last_name")
                         .order("total_orders DESC")
                         .limit(1)

      ["Most Orders Plaed", "#{mop[0].first_name} #{mop[0].last_name}", mop.first.total_orders]
    end

    def average_order_value(n_of_days)
      aov = Order.select("SUM(quantity * price)/COUNT(*) AS avg_order_value").joins("JOIN order_contents ON order_id=orders.id JOIN products ON product_id=products.id").where("checkout_date IS NOT NULL").group("order_id")
    end

end
