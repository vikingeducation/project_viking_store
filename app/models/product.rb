class Product < ActiveRecord::Base
  belongs_to :category
  has_many :order_contents, :class_name => "OrderContents"
  has_many :orders, :through => :order_contents

  validates :name, :price, :category, :sku, :presence => true
  validates :price, :numericality => true, :length =>{ :in => 0..10_000 }


  def self.count_new_products(day_range = nil)
    if day_range.nil?
      Product.all.count
    else
      Product.where("created_at > ?", Time.now - day_range.days).count
    end
  end


  def self.generate_new_sku
    new_sku = (Faker::Code.ean).to_i

    while Product.exists?(:sku => new_sku)
      new_sku = (Faker::Code.ean).to_i
    end

    new_sku
  end



  private


  def self.list_all_skus
    Product.select(:sku).order(:sku)
  end


end
