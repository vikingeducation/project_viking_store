module OrdersHelper

    def total_value(o)
    Order.find_by_sql("SELECT SUM(p.price * oc.quantity) AS total_value
                  FROM orders o JOIN order_contents oc ON o.id = oc.order_id
                  JOIN products p ON oc.product_id = p.id
                  WHERE o.id = #{o.id}
                  ")
  end

end
