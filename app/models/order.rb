class Order < ActiveRecord::Base

  def self.total_orders
    self.count
  end

end
