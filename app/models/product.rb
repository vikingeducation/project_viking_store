class Product < ApplicationRecord
  belongs_to :category

  def self.total_products(day_number = nil)
    day_number.nil? ? Product.all.count : Product.all.where(created_at: day_number.days.ago.beginning_of_day..Time.now).count
  end

end
