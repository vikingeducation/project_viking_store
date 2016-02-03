class OrderContent < ActiveRecord::Base

  def self.revenue_since(start_date)
    total_revenue = 0

    orders = Order.where("created_at > '#{start_date}'")

    orders.each do |order|
      product_table = OrderContent.select("product_id", "quantity").where("order_id = '#{order.id}'")

      # SUM(product_table.quantity * p)

      product_table.each do |product|
        price = Product.select("price").where("id = #{product.product_id}").to_a[0].price
        total_revenue += product.quantity * price
      end
    end

    total_revenue
  end

  def self.total_revenue
    total_revenue = 0

    orders = Order.all

    orders.each do |order|
      product_table = OrderContent.select("product_id", "quantity").where("order_id = '#{order.id}'")

      # SUM(product_table.quantity * p)

      product_table.each do |product|
        price = Product.select("price").where("id = #{product.product_id}").to_a[0].price
        total_revenue += product.quantity * price
      end
    end

    total_revenue
  end
  

end
