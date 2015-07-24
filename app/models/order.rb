class Order < ActiveRecord::Base

  def order_count(timeframe = nil)

    if timeframe.nil?
      return Order.all.length
    else
      return Order.where("created_at > ?", timeframe.days.ago).count
    end
  end
end
