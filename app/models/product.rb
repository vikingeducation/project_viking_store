class Product < ActiveRecord::Base
  validates :name, :description, presence: true
  validates :category_id,
            presence: true
  validates :price,
            numericality: { less_than: 10000 },
            presence: { message: "must be a number" }
  has_many :order_contents, class_name: "OrderContents", dependent: :destroy
  has_many :orders, through: :order_contents
  has_many :users, through: :orders
  belongs_to :category

  def self.total
    count
  end
end
