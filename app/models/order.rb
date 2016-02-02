class Order < ActiveRecord::Base

  def self.last_seven_days
    Order.all.where("checkout_date BETWEEN (NOW() - INTERVAL '7 days') AND NOW()").count
  end


end
