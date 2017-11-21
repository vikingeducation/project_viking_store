class Product < ApplicationRecord

  belongs_to :category
  has_many :order_contents
  has_many :orders, through: :order_contents

  include CountSince

  validates :price,
            presence: true
  validates :name,
            presence: true


  def self.product_statistics
    product_stats_hash = {}
    product_stats_hash[:sevendays] = count_since(7.days.ago)
    product_stats_hash[:thirtydays] = count_since(30.days.ago)
    product_stats_hash[:total] = count_since((Order.select(:created_at).first).created_at)
    product_stats_hash
  end

  def price=(price)
    price = price.gsub('$', '')
    write_attribute(:price, price)
  end


end
