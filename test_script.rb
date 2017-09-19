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

# Order Associations
o.user
# belongs_to :user in Order

o.products
# has_many :products, :through => :order_contents in Order
# belongs_to :product in OrderContent

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






# Work on these associations


u.products      # bonus
u.default_billing_address_id
u.default_shipping_address_id

o.categories    # bonus

c.orders        # bonus
