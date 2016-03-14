class Order < ActiveRecord::Base
  def created_since_days_ago(number)
    Order.all.where('checkout_date >= ?', number.days.ago).count
  end
end
