class Product < ApplicationRecord
  extend Dateable

  validates :name, :price, presence: true
  validates :price, numericality: {less_than_or_equal_to: 10000}, unless: -> { price.blank? }
  validates :category, category: true

  before_save :set_sku

  belongs_to :category
  delegate :name, to: :category, prefix: true

  def times_ordered
    Order.with_products.checked_out.where(products: {id: self}).count
  end

  def carts_in
    Order.with_products.where(products: {id: self}).count
  end

  private

  def set_sku
    self.sku = Faker::Code.ean
  end
end
