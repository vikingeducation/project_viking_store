class OrderContent < ActiveRecord::Base

  def self.revenue(days=nil)
    if days.nil?
      self.joins("JOIN products ON product_id = products.id").sum("products.price * order_contents.quantity")
    else
      self.joins("JOIN products ON product_id = products.id").where("order_contents.created_at > CURRENT_DATE - interval '#{days} day' ").sum("products.price * order_contents.quantity")
    end
  end

end
