class Dashboard < ActiveRecord::Base
  def total_revenue
    Order.count
  end
end
