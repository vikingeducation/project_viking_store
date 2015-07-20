class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_contents, :class_name => "OrderContents"
  has_many :orders, :through => :order_contents

  validates :name, :price, :category, :presence => true
  validates :price, :numericality => true

  def self.count_new_products(day_range = nil)
    if day_range.nil?
      Product.all.count
    else
      Product.where("created_at > ?", Time.now - day_range.days).count
    end
  end


end
