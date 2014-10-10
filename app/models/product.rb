class Product < ActiveRecord::Base

  has_many :purchases
  has_many :orders, through: :purchases

  belongs_to :category

  validates :price,
            :presence => true,
            :allow_blank => false,
            :allow_nil => false,
            :numericality => { :less_than_or_equal_to => 10_000 }

  validates :name,
            :presence => true,
            :allow_blank => false,
            :allow_nil => false

  validates :category_id,
            :presence => true,
            :allow_blank => false,
            :allow_nil => false

  def self.new_products(last_x_days = nil)
    if last_x_days
      where("created_at > ?", Time.now - last_x_days.days).size
    else
      all.size
    end
  end

end
