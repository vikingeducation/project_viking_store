class Product < ActiveRecord::Base

  def self.total_listed(period = nil)
    total = Product.select("COUNT(*) AS t")
    if period
      total = total.where( "created_at BETWEEN :start AND :finish",
                          { start: DateTime.now - period, finish: DateTime.now } )
    end
    total.to_a.first.t
  end


  def self.all_products_order_stats
    joins("LEFT OUTER JOIN order_contents ON order_contents.product_id = products.id").
    joins("LEFT OUTER JOIN orders ON order_contents.order_id = orders.id").
    select("COUNT(orders.checkout_date) AS completed_orders, COUNT(orders.id) AS total_orders,
            products.id").
    group("products.id")
  end


  def self.with_category_names
    join_with_categories.select("products.name AS name, categories.name AS category,
                                         products.*")
  end


  def self.join_with_categories
    joins("LEFT OUTER JOIN categories ON products.category_id = categories.id")
  end

  # instance methods
  def order_stats
    s = Product.all_products_order_stats.where("products.id = #{id}").first
    {carts: (s.total_orders - s.completed_orders), orders: s.completed_orders}
  end

end
