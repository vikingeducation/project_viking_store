class Product < ApplicationRecord
  validates :name,
            :price,
            :category_id,
            :sku,
            presence: true

  validates :name,
            :sku,
            uniqueness: true

  validates :sku,
            numericality: { only_integer: true },
            length: { is: 13 }

  validates :price,
            numericality: {
              greater_than_or_equal_to: 0,
              less_than_or_equal_to: 10000
            }

  validates :category_id, inclusion: { in: Category.pluck(:id) }

  # A Product belongs to a single Category.
  belongs_to :category

  # A Product can belong to many Orders through OrderContents.
  # If a Product is destroyed, do we want to nullify or destroy all associated rows in OrderContents?
  # It seems that if we nullify the product_id in a OrderContent row, we won't be able to know what Product in that Order.
  # If we destroy the relevant row, that seems to have the same effect?
  has_many :order_contents, dependent: :nullify
  has_many :orders, through: :order_contents


  # calculates the number of new Products that were added within a number of
  # days from the current day
  def self.new_products(within_days)
    Product.where("created_at >= ? ", Time.now - within_days.days).count
  end

  # finds all Products that belong to a particular Category.
  # orders by Product name.
  def self.products_in_category(category_id)
    Product.where(category_id: category_id).order(:name)
  end

  # sets the category_id of all Products that belong to a
  # particular Category to nil, to disassociate the Product
  # from the Category when the Category is deleted
  def self.clear_products_category(category_id)
    products = Product.where(category_id: category_id)

    products.map { |product| product.update(category_id: nil) }
  end

  # finds the Category name of a specific Product.
  def self.category_name(product)
    Category.find_by(id: product.category_id).name
  end

  # finds the number of Orders this Product appears in.
  def self.in_num_orders(product)
    self.in_orders_or_carts(product)
    .where("orders.checkout_date IS NOT NULL")
    .count
  end

  # finds the number of shopping carts this Product appears in.
  def self.in_num_shopping_carts(product)
    self.in_orders_or_carts(product)
    .where("orders.checkout_date IS NULL")
    .count
  end

  private

  # finds the Orders OR shopping carts this Product appears in.
  def self.in_orders_or_carts(product)
    Product
    .joins("JOIN order_contents ON products.id = order_contents.product_id")
    .joins("JOIN orders ON orders.id = order_contents.order_id")
    .where("products.id = ?", product.id)
    .select("DISTINCT orders.id")
  end
end
