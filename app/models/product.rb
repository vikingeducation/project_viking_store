class Product < ActiveRecord::Base
  validates :name, :price, :category_id, :presence => true

  validates :price, :numericality => { :less_than_or_equal_to => 10000 }

  validates :category_id, :inclusion => (Category.ids)

  def self.total
    Product.all.count
  end

  def self.new_products(t)
    Product.where("created_at > CURRENT_DATE - INTERVAL '#{t} DAYS' ").count
  end

  def self.by_category(c)
    Product.where("category_id = ?", c)
  end

  def self.all_with_category
    Product.select("p.id, p.name, p.price, c.name AS cname, p.category_id AS cid")
    .joins("AS p JOIN categories c ON p.category_id = c.id")
  end

end
