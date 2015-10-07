class Product < ActiveRecord::Base

  def self.count_new_products(day_range = nil)

    if day_range.nil?
      Product.all.count
    else
      Product.where("created_at > ?", Time.now - day_range.days).count
    end

  end
  
  def self.generate_new_sku

    new_sku = (Faker::Code.ean).to_i

  end

  def self.list_all_skus

    Product.select(:sku).order(:sku)

  end

end
