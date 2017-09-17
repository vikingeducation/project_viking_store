u = User.first
o = Order.first
p = Product.first
c = Category.first
a = Address.first

# User Associations
u.addresses
u.orders
u.products      # bonus
u.default_billing_address_id
u.default_shipping_address_id

# Order Associations
o.user
o.products
o.categories    # bonus

# Product Associations
p.orders
p.category

# Category Associations
c.products
c.orders        # bonus

# Address Associations
a.user