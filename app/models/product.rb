class Product < ActiveRecord::Base

  has_many :order_contents
  has_many :orders, through: :order_contents
  belongs_to :category

  validates :name,
      :presence => true,
      :allow_nil => false

  validates :sku,
      :presence => true,
      :allow_nil => false,
      :allow_blank => false,
      numericality: {is_integer: true},
      length: { maximum: 20 }

  validates :price,
            :presence => true,
            :allow_nil => false,
            :numericality => { :less_than_or_equal_to => 10_000 }

  validates :category_id,
            :presence => true,
            :allow_nil => false

  def self.number
    return Product.all.count
  end

  def self.number_in(days)
    self.where("created_at > ?",Time.now - days.day).count
  end

end
