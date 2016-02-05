Project: Viking Store Admin
=============================

Julia + Andrew

Load time with multiplier = 10: Time taken is 0.108385478.
Load time with multiplier = 50: Time taken is 0.369374212.

ASSOCIATIONS:
ADDRESS = many-to-one with users, an address can only have one user
CATEGORY = one-to-many with products, many products in the same category
? CITY = one-to-many with addresses, city can be part of many addresses
CREDIT CARD = many-to-one with users, can have many credit cards per user
ORDER = many-to-one with users, one-to-many with order_contents, one-to-one with address(shipping) and address (billing)
ORDER_CONTENTS (join table for orders and products - has product quantity too), belongs_to :order, belongs_to product
PRODUCT = many-to-one with categories, product can only have one category
? STATE = one-to-many with addresses, state can be part of many addresses
USER = one-to-many with addresses, one-to-many with orders, one-to-many with credit cards


##To Get Going On This App:
- run `rake db:create` (you might need to do `bundle exec rake db:create`)
- run `rake db:migrate`
- run `rake db:seed`


Link to solution info on the seeding of this lives [here](https://gist.github.com/betweenparentheses/0b6b325ceaaea76a521d)
