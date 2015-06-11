
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


# Blow away all the existing records every time.

User.destroy_all
Address.destroy_all
Order.destroy_all
OrderContents.destroy_all
Category.destroy_all
CreditCard.destroy_all
Product.destroy_all
State.destroy_all
City.destroy_all


# MULTIPLIER is used to create a predictable ratio of records. For instance, we will have 10 Product records for every Category.
MULTIPLIER = 10


# This seeds the random number generator so the rest of this file behaves predictably. (This was definitely not part of your assignment.)
srand(42)


# Generate Category records for your Product records.

MULTIPLIER.times do
  category = Category.new
  category[:name]        = Faker::Commerce.department
  category[:description] = Faker::Lorem.sentence
  category.save
end


# Generate Product records and assign them each to a random Category.

(MULTIPLIER * 10).times do
  p = Product.new
  p[:name]        = Faker::Commerce.product_name
  p[:category_id] = Category.pluck(:id).sample
  p[:description] = Faker::Lorem.sentence
  p[:sku]         = (Faker::Code.ean).to_i
  p[:price]       = Faker::Commerce.price
  p.save
end


# Generate the State records.

STATES =
["Alabama", "Alaska", "Arizona", "Arkansas", "California",
"Colorado", "Connecticut", "Delaware", "Florida", "Georgia",
"Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
"Kansas", "Kentucky", "Louisiana", "Maine", "Maryland",
"Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri",
"Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey",
"New Mexico", "New York", "North Carolina", "North Dakota", "Ohio",
"Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina",
"South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
"Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

STATES.each do |state|
  state = State.new({:name => state})
  state.save
end


# Generate some City records. Your Address model could have also included "city" as a string instead of a foreign key.

(MULTIPLIER * 10).times do
  City.create( :name => Faker::Address.city )
end


# Because seeds.rb is run as a script, you'll need to put helper methods ABOVE where they are used to generate records.

# This method selects one of a users several addresses for use setting shipping address and billing address.

def random_user_address(user_id)
  address_choices = (Address.select(:id).where(:user_id => user_id)).to_a
  address_choices.sample[:id]
end


# This method creates 1 to 4 addresses associated with a specific user.

def generate_addresses(user_id)
  (rand(4) + 1).times do
    a = Address.new
    a[:user_id] = user_id
    a[:street_address] = Faker::Address.street_address
    a[:city_id] = City.select(:id).sample.id
    a[:state_id] = State.select(:id).sample.id
    a[:zip_code] = Faker::Address.zip.to_i
    a.save! #just to check if anything fails here
  end
end


# This method returns a date that's random but weighted toward the current date.

def creation_date
  time_frames = []
  (MULTIPLIER**2).times do |x|
     time_frames << Time.now - ((x*3) + 1).month
  end
  date_range = (time_frames.sample..Time.now)
  rand(date_range)
end


# Create your User records.
(MULTIPLIER * 10).times do

  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  u = User.new
  u[:first_name]  = first_name
  u[:last_name]   = last_name
  u[:email]       = Faker::Internet.email("#{first_name} #{last_name}")
  u[:created_at]  = creation_date
  u.save

  # Create affilliated addresses and select billing and shipping addresses.
  generate_addresses(u.id)
  u[:billing_id]  = random_user_address(u.id)
  u[:shipping_id] = random_user_address(u.id)
  u.save
end


# Here are some methods that will help us create Order records.

# This method adds random Product records to Orders through the OrderContents model.

def generate_contents(order_id)
  (rand(10)+1).times do
    c = OrderContents.new
    c[:order_id]   = order_id
    c[:product_id] = Product.pluck(:id).sample
    c[:quantity]   = rand(10)+1

    # prevents breaking the uniqueness constraint on
    # [:order_id, :product_id]
    if OrderContents.where(:product_id => c.product_id,
                          :order_id => c.order_id).empty?
      c.save
    end
  end
end


# This method tells us whether a specific user already has a shopping cart, i.e. an order that has not been checked out.
#  #present? is a Rails method that's the opposite of #empty?

def has_cart?(user_id)
  Order.where("user_id = ? AND checkout_date IS NULL ", user_id).present?
end


# This method generates a random timestamp between when the user was created and right now.
def placement_date(user)
  rand(user[:created_at]..Time.now)
end


# Now we can finally create some Order records.

(MULTIPLIER * 30).times do

  user = User.all.sample

  # 2 kinds of users can have orders built
  # a user with a billing address is one
  # a user who still needs a shopping cart built is the other
  if user[:billing_id] || !has_cart?(user[:id])
    o = Order.new
    o[:user_id]       = user.id
    o[:shipping_id]   = random_user_address(user.id)
    o[:billing_id]    = random_user_address(user.id)

    # first generated order is a shopping cart
    # all since then are placed orders with checkout dates
    if has_cart?(user.id)
      o[:checkout_date] = placement_date(user)
    end

    o.save
    generate_contents(o[:id])
  end
end


# Create some CreditCard records for users who have an order.
users_with_orders = Order.all.select("DISTINCT user_id").
                              where("checkout_date IS NOT NULL")

users_with_orders.each do |user|
  card = CreditCard.new
  card[:user_id] = user.user_id

  # last 4 digits only
  card[:card_number] = Faker::Number.number(4)
  card[:exp_month] = rand(12) + 1

  #so far, only good cards
  card[:exp_year] = Time.now.year + rand(5)
  card[:brand] = ['VISA', 'MasterCard', 'Discover', 'Amex'].sample

  # for when card numbers collide
  card.save if CreditCard.
               where(:card_number => card.card_number).empty?
end
