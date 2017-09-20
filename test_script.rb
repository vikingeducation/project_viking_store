u = User.first
o = Order.first
p = Product.first
c = Category.first
a = Address.first

# User Associations
u.addresses
# has_many :addresses in User and belongs_to :user in Address

u.orders
# has_many :orders in User

u.products      # bonus
# has_many :order_contents, through: :orders
  # has_many :products, :through => :order_contents in User

# has_many :orders, :through => :order_contents in Orders

u.default_billing_address_id
# belongs_to :default_billing_address, :foreign_key => :billing_id,
            # :class_name => "Address"

u.default_shipping_address_id
  # belongs_to :default_shipping_address, :foreign_key => :shipping_id,
  #           :class_name => "Address"


# Order Associations
o.user
# belongs_to :user in Order

o.products
# has_many :products, :through => :order_contents in Order
# belongs_to :product in OrderContent

o.categories    # bonus
# has_many :products, :through => :order_contents in Order
  # has_many :categories, :through => :products in Order

# Product Associations
p.orders
# has_many :orders, :through => :order_contents in Product
# belongs_to :order in OrderContent

p.category
# belongs_to :category in Products

# Category Associations
c.products
# has_many :products in Category


# Address Associations
a.user
# belongs_to :user in Address


c.orders        # bonus
# has_many :order_contents, :through => :products in Category
  # has_many :orders, :through => :order_contents in Category
