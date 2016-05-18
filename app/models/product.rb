class Product < ActiveRecord::Base
  has_many :order_contents
  has_many :orders, :through => :order_contents
  belongs_to :category



  validates :name, :price, :category_id, :presence => true

  validates :price, :numericality => { :less_than_or_equal_to => 10000 }

  validates :category_id, :inclusion => {in: Category.ids}

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
