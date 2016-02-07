Project: Viking Store Admin
=============================

Julia + Andrew + Jeff


##To Get Going On This App:
- run `rake db:create` (you might need to do `bundle exec rake db:create`)
- run `rake db:migrate`
- run `rake db:seed`


Load time with multiplier = 10: Time taken is 0.108385478.
Load time with multiplier = 50: Time taken is 0.369374212.

===================
ASSOCIATIONS:
===================
ADDRESS = many-to-one with users, an address can only have one user
CATEGORY = one-to-many with products, many products in the same category
CITY = one-to-many with addresses, city can be part of many addresses
CREDIT CARD = many-to-one with users, can have many credit cards per user, one-to-many with orders
ORDER = many-to-one with users, one-to-many with order_contents, one-to-one with address(shipping) and address (billing)
ORDER_CONTENTS (join table for orders and products - has product quantity too), belongs_to :order, belongs_to product
PRODUCT = many-to-one with categories, product can only have one category
STATE = one-to-many with addresses, state can be part of many addresses
USER = one-to-many with addresses, one-to-many with orders, one-to-many with credit cards


u = User.first
o = Order.first
p = Product.first
ct = Category.first
a = Address.first

# User Associations
u.addresses
u.orders
u.product
u.default_billing_address_id
u.default_shipping_address_id

# Order Associations
o.user
o.products
o.categories

# Product Associations
p.orders
p.category

# Category Associations
ct.products
ct.orders

# Address Associations
a.user

===================
DEPENDENCIES
===================
What happens when you delete a(n)...
ADDRESS = nothing, users/states/cities should stick around
CATEGORY = all associated products' category_id's should be null
CITY = can you even delete a city, or just an address?
CREDIT CARD = nothing, users/orders should remain
ORDER = should remove rows in order_contents join table?
ORDER_CONTENTS = n/a
PRODUCT = nothing, category should remain
STATE = nothing
USER = destroy credit card, addresses/orders/products should stay


Link to solution info on the seeding of this lives [here](https://gist.github.com/betweenparentheses/0b6b325ceaaea76a521d)




class Address
  after_create :make_or_save_city

  def make_or_save_city

  end

  def city_name=(name)
    city = City.find_or_create_by(name: name)
    self.city = city
    self.save!
  end

end