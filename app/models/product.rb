class Product < ActiveRecord::Base
  def self.total
    self.count
  end

  def self.new_products(days_since)
    self.where("created_at > '#{DateTime.now - days_since}'").count
  end
end
