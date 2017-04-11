class Product < ApplicationRecord

  def self.seven_days_products
    where('created_at > ?', (Time.zone.now.end_of_day - 7.days)).count
  end

  def self.month_products
    where('created_at > ?', (Time.zone.now.end_of_day - 30.days)).count
  end

  def self.total_products
    count
  end


end
