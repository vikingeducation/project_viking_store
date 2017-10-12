class User < ApplicationRecord

  attr_accessor :user_stats, :user_demographics

  def user_stats
    user_stats_hash = {}
    user_stats_hash[:seven] = overall_count(User, SEVEN_DAYS)
    user_stats_hash[:thirty] = overall_count(User, THIRTY_DAYS)
    user_stats_hash[:total] = overall_count(User, FIRST_ORDER_DATE.created_at)
    user_stats_hash
  end

  def user_demographics
    user_demo_hash = {}
    user_demo_hash[:highest_single_order] = highest_single_value_order
    user_demo_hash[:highest_lifetime_order] = highest_lifetime_value_order
    user_demo_hash[:highest_average_order] = highest_average_value_order
    user_demo_hash[:most_orders] = most_orders_placed
    user_demo_hash
  end


  private


  def highest_single_value_order
    id_and_value = Order.join_ordercontents_onto_orders
                        .join_products_onto_ordercontents
                        .group('order_contents.order_id, orders.user_id')
                        .order('sum(products.price * order_contents.quantity) DESC')
                        .limit(1)
                        .sum(REVENUE)
                        .map_value_to_float
                        .flatten
    value_and_name(id_and_value)
  end


  def highest_lifetime_value_order
    id_and_value = Order.join_ordercontents_onto_orders
                        .join_products_onto_ordercontents
                        .group('orders.user_id').limit(1)
                        .sum(REVENUE)
                        .map_value_to_float.flatten
    value_and_name(id_and_value)
  end


  def highest_average_value_order
    id_and_value = Order.join_ordercontents_onto_orders
                        .join_products_onto_ordercontents
                        .group('order_contents.order_id, orders.user_id')
                        .limit(1)
                        .average(REVENUE)
                        .map_value_to_float
                        .flatten
    value_and_name(id_and_value)
  end


  def most_orders_placed
    user_id_relation = Order.select(:user_id).group(:user_id).order('count(user_id) DESC').limit(1)

    id_and_value = Order.join_ordercontents_onto_orders
                        .join_products_onto_ordercontents
                        .group(:user_id).where(:user_id => user_id_relation)
                        .sum(REVENUE)
                        .map_value_to_float
                        .flatten
    value_and_name(id_and_value)
  end


  def value_and_name(id_and_value)
    { customer_name: user_name(id_and_value), order_value: value_of_order(id_and_value) }
  end
  

  def value_of_order(id_and_value)
    value = id_and_value[1]
  end


  def user_name(id_and_value)
    user_info = User.find(id_and_value[0])
    user_name = user_info.first_name + ' ' + user_info.last_name
  end



end
