class Category < ActiveRecord::Base

  has_many :products

  has_many :order_contents, :through => :products

  has_many :orders, :through => :order_contents, source: :order

  validates :name, presence: true, length: { in: 4..16 }, uniqueness: true

end
