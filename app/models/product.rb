class Product < ActiveRecord::Base
  has_many :order_contents

  def self.new_products(num_days)
    Product.where("created_at <= ? ", num_days.days.ago)
  end
end
