class TopCustomer
  def self.highest_order
    fetch orders_and_grouped_by_user.
            group("orders.id").
            order("total DESC")
  end

  def self.highest_lifetime_value_customer
    fetch orders_and_grouped_by_user.
            order("total DESC")
  end

  def self.highest_average_order
    fetch Order.select("customer_name, AVG(total) AS average").
      from(orders_and_grouped_by_user.group("orders.id")).
      group("customer_name").
      order("average DESC")

  end

  def self.must_orders_placed
    fetch orders_and_grouped_by_user.
      select("COUNT(*) AS count").
      group("orders.id").
      order("count DESC")
  end

  def self.orders_and_grouped_by_user
    Order.with_products_and_users.
      select("concat(users.first_name, ' ', users.last_name) AS customer_name, SUM(products.price) AS total").
      where.not(orders: {checkout_date: nil}).
      group("users.id")
  end

  def self.fetch(relation)
    relation.limit(1).first
  end
end
