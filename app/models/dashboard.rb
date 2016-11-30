class Dashboard

  def get_revenue(n_of_days)
    Order.joins("JOIN order_contents ON orders.id=order_id
                 JOIN products ON products.id=product_id")
                 .where("checkout_date > NOW() - INTERVAL '? days'", n_of_days)
                 .sum("quantity * price")
  end

end
