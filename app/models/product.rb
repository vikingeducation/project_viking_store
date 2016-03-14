class Product < ActiveRecord::Base

  has_many :order_contents
  has_many :orders, :through => :order_contents

  def self.created_since_days_ago(number)
    Product.all.where('created_at >= ?', number.days.ago).count
  end
end
