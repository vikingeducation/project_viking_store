class Order < ActiveRecord::Base
  def self.created_since_days_ago(number)
    Order.all.where('checkout_date >= ?', number.days.ago).count
  end
end
