class Admin::Analysis::TopCustomer
  class << self
    def with_highest_single_order
      fetch orders_by_user.group("orders.id")
    end

    def with_highest_lifetime_value
      fetch orders_by_user
    end

    def with_must_orders_placed
      fetch orders_by_user.
      select("COUNT(*) AS count").
      group("orders.id").
      order("count DESC")
    end

    def all
      {
        with_highest_single_order: with_highest_single_order,
        with_highest_lifetime_value: with_highest_lifetime_value,
        with_must_orders_placed: with_must_orders_placed
      }
    end

    private

    def orders_by_user
      Order.with_products_and_users.
      checked_out.
      select("users.id, concat(users.first_name, ' ', users.last_name) AS customer_name, SUM(products.price) AS sum").
      group("users.id").
      order("sum DESC")
    end

    def fetch(relation)
      relation.limit(1).first
    end
  end
end
