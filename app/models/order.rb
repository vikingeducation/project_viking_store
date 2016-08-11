class Order < ActiveRecord::Base
  def self.created_last_seven_days
    Order.where('created_at > ?', Time.now - 7.days)
  end

  def self.created_last_thirty_days
    Order.where('created_at > ?', Time.now - 30.days)
  end
end
