class Product < ActiveRecord::Base
  def self.number
    return Product.all.count
  end

  def self.number_in(days)
    self.where("created_at > ?",Time.now - days.day).count
  end

end
