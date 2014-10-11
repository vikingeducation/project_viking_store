module Faker
  class MakeDate < Base
    class << self
      def months_ago(months=1)
        #return a random day in the past 7 days
        today = ::Date.today
        today = today.downto(today - (30*months)).to_a
        today.shuffle[0]
      end
    end
  end
end


namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    SEED_MULTIPLIER = 3
    
    gen_addresses
    gen_users
    gen_categories
    gen_products
    gen_orders


    make_users
    make_address
    make_product
    make_category
    make_payment
    make_order
    make_order_contents


  end
end

def gen_addresses
   @addresses = (1..(100*SEED_MULTIPLIER)).to_a
end

def gen_users
  @users = (1..(330*SEED_MULTIPLIER)).to_a
end

def gen_categories
  @categories = (1..(6*SEED_MULTIPLIER)).to_a
end

def gen_products
  @products = (1..(50*SEED_MULTIPLIER)).to_a
end

def gen_orders
  @orders = (1..(200*SEED_MULTIPLIER)).to_a
end

def make_product
  (@products.length).times do |n| #create products
    title = Faker::Commerce.product_name
    description = Faker::Hacker.say_something_smart
    price = Faker::Commerce.price
    sku = Faker::Lorem.characters(6)
    create = Faker::MakeDate.months_ago(2)
    cat_id = @categories.sample
    Product.create!(title: title, description: description,
      price: price, sku: sku, category_id: cat_id, created_at: create)
  end
end

def make_users #make da usahs (total users is 330*SEED_MULTIPLIER)
  (10*SEED_MULTIPLIER).times do |n| #users from 6 months ago
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::Number.number(10)
    create = Faker::MakeDate.months_ago(6)
    billing_address = @addresses.sample
    shipping_address = @addresses.sample
    User.create!(first_name: first_name, last_name: last_name, 
    email: email, phone: phone, created_at: create,
    default_billing_address_id: billing_address,
    default_shipping_address_id: shipping_address)
  end

  (20*SEED_MULTIPLIER).times do |n| #users from 5 months ago
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::Number.number(10)
    create = Faker::MakeDate.months_ago(5)
    billing_address = @addresses.sample
    shipping_address = @addresses.sample
    User.create!(first_name: first_name, last_name: last_name, 
    email: email, phone: phone, created_at: create,
    default_billing_address_id: billing_address,
    default_shipping_address_id: shipping_address)
  end

  (40*SEED_MULTIPLIER).times do |n| #40 users from 4 months ago
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::Number.number(10)
    create = Faker::MakeDate.months_ago(4)
    billing_address = @addresses.sample
    shipping_address = @addresses.sample
    User.create!(first_name: first_name, last_name: last_name, 
    email: email, phone: phone, created_at: create,
    default_billing_address_id: billing_address,
    default_shipping_address_id: shipping_address)
  end

  (60*SEED_MULTIPLIER).times do |n| #60 users from 3 months ago
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::Number.number(10)
    create = Faker::MakeDate.months_ago(3)
    billing_address = @addresses.sample
    shipping_address = @addresses.sample
    User.create!(first_name: first_name, last_name: last_name, 
    email: email, phone: phone, created_at: create,
    default_billing_address_id: billing_address,
    default_shipping_address_id: shipping_address)
  end

  (80*SEED_MULTIPLIER).times do |n| #80 users from 2 months ago
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::Number.number(10)
    create = Faker::MakeDate.months_ago(2)
    billing_address = @addresses.sample
    shipping_address = @addresses.sample
    User.create!(first_name: first_name, last_name: last_name, 
    email: email, phone: phone, created_at: create,
    default_billing_address_id: billing_address,
    default_shipping_address_id: shipping_address)
  end

  (120*SEED_MULTIPLIER).times do |n| #120 users from 1 months ago
    first_name = Faker::Name.first_name
    last_name = Faker::Name.last_name
    email = Faker::Internet.email
    phone = Faker::Number.number(10)
    create = Faker::MakeDate.months_ago(1)
    billing_address = @addresses.sample
    shipping_address = @addresses.sample
    User.create!(first_name: first_name, last_name: last_name, 
    email: email, phone: phone, created_at: create,
    default_billing_address_id: billing_address,
    default_shipping_address_id: shipping_address)
  end

end

def make_address
   (1..@users.length).each do |n| #everyone gets a first address
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.state_abbr
    zip = Faker::Address.zip
    Address.create(user_id: n, street_address: street,
      city: city, state: state, zip: zip)
   end
  (1..((@users.length)/2)).each do |n| #half the users get a second address
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.state_abbr
    zip = Faker::Address.zip
    Address.create(user_id: n, street_address: street,
      city: city, state: state, zip: zip)
   end

   (1..((@users.length)/3)).each do |n| #one-third of users get a third address
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.state_abbr
    zip = Faker::Address.zip
    Address.create(user_id: n, street_address: street,
      city: city, state: state, zip: zip)
   end

  (1..((@users.length)/4)).each do |n| #one-fourth of users get a fourth address
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.state_abbr
    zip = Faker::Address.zip
    Address.create(user_id: n, street_address: street,
      city: city, state: state, zip: zip)
   end

  (1..((@users.length)/5)).each do |n| #one-fifth of users get a fifth address
    street = Faker::Address.street_address
    city = Faker::Address.city
    state = Faker::Address.state_abbr
    zip = Faker::Address.zip
    Address.create(user_id: n, street_address: street,
      city: city, state: state, zip: zip)
   end
end

def make_payment
  months, years = [],[]
  (1..12).each {|i| months << i}
  (2014..2020).each {|i| years << i}
  (1..@users.length).each do |n|
      cc = Faker::Number.number(16)
      exp_month = months.sample
      exp_year = years.sample
      ccv = rand(999)
      Payment.create!(user_id: n, cc_number: cc, exp_month: exp_month,
        exp_year: exp_year, ccv: ccv)
  end
end

def make_category
  (1..@categories.length).each do |n| #6 categories
    name = Faker::Lorem.words(2)[0]
    description = Faker::Hacker.say_something_smart
    Category.create!(name: name, description: description)
  end
end


def make_order_contents
  (1..100*SEED_MULTIPLIER).each do |i| #100-scaled initial orders
    product_id = @products.sample
    quantity = (1..10).to_a.sample
    current_price = Product.find(product_id).price
    OrderContent.create!(product_id: product_id,
      order_id: i, quantity: quantity, current_price: current_price)
  end

  (1..@orders.length).each do |n|
    product_id = @products.sample
    quantity = (1..10).to_a.sample
    current_price = Product.find(product_id).price
    OrderContent.create!(product_id: product_id,
      order_id: ((100*SEED_MULTIPLIER)+n), quantity: quantity, current_price: current_price)
  end
end


def make_order
  (100*SEED_MULTIPLIER).times do |i| #100-scaled placed orders
    user_id = @users.sample
    billing = Address.where(user_id: user_id).sample.id
    shipping = Address.where(user_id: user_id).sample.id
    placed_at = Faker::MakeDate.months_ago(4)
    Order.create!(user_id: user_id, billing_address_id: billing,
      shipping_address_id: shipping, is_placed: true, placed_at: placed_at)
  end

  (@orders.length).times do |i| #100-scaled non-placed orders (carts)
    user_id = @users.sample
    billing = Address.where(user_id: user_id).sample.id
    shipping = Address.where(user_id: user_id).sample.id
    placed_at = Faker::MakeDate.months_ago(4)
    Order.create!(user_id: user_id, billing_address_id: billing,
      shipping_address_id: shipping, is_placed: false, placed_at: placed_at)
  end

end
