class OrderContent < ActiveRecord::Base
  belongs_to :order
  belongs_to :product

  def revenue(timeframe = nil)
    if timeframe.nil?
      OrderContent.select("ROUND(SUM(quantity * products.price), 2) AS total")
                  .joins("JOIN products ON order_contents.product_id=products.id")
                  .first.total
    else
      OrderContent.select("ROUND(SUM(quantity * products.price), 2) AS total")
                  .joins("JOIN products ON order_contents.product_id=products.id")
                  .where("order_contents.created_at > ?", timeframe.days.ago)
                  .first.total
    end
  end
end
