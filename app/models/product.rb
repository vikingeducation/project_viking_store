class Product < ActiveRecord::Base

  def self.count_last(num_days_ago)
    Product.where("updated_at > ?", num_days_ago.days.ago).count
  end
end
