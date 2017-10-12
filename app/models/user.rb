class User < ApplicationRecord

  attr_accessor :user_stats, :user_demographics

  def user_stats
    user_stats_hash = {
      seven: User.where('created_at >= ?', 7.days.ago).count  #turn these into helper methods that take the model and number of days
      thirty: User.where('created_at >= ?', 30.days.ago).count #turn these into helper methods that take the model and number of days
      total: User.all.count
    }
  end

  def user_demographics
    user_demo_hash = {
      highest_single_order: highest_single_value_order
      highest_lifetime_order: highest_lifetime_value_order
      highest_average_order: highest_average_value_order
      most_orders: most_orders_placed
    }
  end


  private


  def highest_single_value_order
    id_and_value = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id')
                        .joins('JOIN products ON products.id = order_contents.product_id')
                        .group('order_contents.order_id, orders.user_id')
                        .order('sum(products.price * order_contents.quantity) DESC')
                        .limit(1)
                        .sum('products.price * order_contents.quantity')
                        .map{|k,v| [k, v.to_f] }
                        .flatten
    value_and_name = { order_value: value_of_order(id_and_value), customer_name: user_name(id_and_value) }
  end


  def highest_lifetime_value_order
    id_and_value = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id') #turn into helper method
                        .joins('JOIN products ON products.id = order_contents.product_id') #turn into helper method
                        .group('orders.user_id').limit(1)
                        .sum('products.price * order_contents.quantity')
                        .map{|k,v| [k, v.to_f] }.flatten
    value_and_name = { order_value: value_of_order(id_and_value), customer_name: user_name(id_and_value)}
  end


  def highest_average_value_order
    id_and_value = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id') #turn into helper method
                        .joins('JOIN products ON products.id = order_contents.product_id') #turn into helper method
                        .group('order_contents.order_id, orders.user_id')
                        .limit(1)
                        .average('products.price * order_contents.quantity')
                        .map{|k,v| [k, v.to_f] }
                        .flatten
    value_and_name = { order_value: value_of_order(id_and_value), customer_name: user_name(id_and_value)}
  end


  def most_orders_placed
    user_id_relation = Order.select(:user_id).group(:user_id).order('count(user_id) DESC').limit(1)

    id_and_value = Order.joins('JOIN order_contents ON orders.id = order_contents.order_id') #turn into helper method
                        .joins('JOIN products ON products.id = order_contents.product_id') #turn into helper method
                        .group(:user_id).where(:user_id => user_id_relation)
                        .sum('products.price * order_contents.quantity')
                        .map{|k,v| [k, v.to_f] }
                        .flatten
    value_and_name = { order_value: value_of_order(id_and_value), customer_name: user_name(id_and_value)}
  end


  def value_of_order(id_and_value)
    value = id_and_value[1]
  end


  def user_name(id_and_value)
    user_info = User.find(id_and_value[0])
    user_name = user_info.first_name + ' ' + user_info.last_name
  end



end
