class Product < ActiveRecord::Base
  def self.created_since_days_ago(number)
    Product.all.where('created_at >= ?', number.days.ago).count
  end
end
