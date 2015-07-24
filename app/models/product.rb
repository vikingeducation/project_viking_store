class Product < ActiveRecord::Base

  def self.product_created_days_ago(num_days)
    self.where("created_at > ?",Time.now - num_days.day).count
  end
end
