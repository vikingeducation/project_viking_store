
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

#BLOW AWAY EVERYTHING EVEN IF YOU DON'T RUN rake db:reset

User.destroy_all
Address.destroy_all
Order.destroy_all
OrderContents.destroy_all
Category.destroy_all
CreditCard.destroy_all
Product.destroy_all
State.destroy_all
City.destroy_all




# Seed multiplier
MULTIPLIER = 10
#seed random numbers to work predictably
srand(42)

#generate products
sample_categories = []

MULTIPLIER.times do
  sample_categories << Faker::Commerce.department
end

sample_categories.each do |name|
  category = Category.new()
  category[:name]        = name
  category[:description] = Faker::Lorem.sentence
  category.save
end

(MULTIPLIER * 10).times do
  p = Product.new()
  p[:name]        = Faker::Commerce.product_name
  p[:category_id] = Category.pluck(:id).sample
  p[:description] = Faker::Lorem.sentence
  p[:sku]         = (Faker::Code.ean).to_i
  p[:price]       = Faker::Commerce.price
  p.save
end

#generate addresses, MULTIPLIER*111 cities
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

(MULTIPLIER * 10).times do
  City.create( :name => Faker::Address.city )
end





# picks all of a user's addresses, returns an id of one of them
# for use setting shipping address and billing address
def random_user_address(user_id)
  address_choices = (Address.select(:id).where(:user_id => user_id)).to_a
  address_choices[0] ? address_choices.sample[:id] : nil
end

def generate_addresses(user_id)
  (rand(5)).times do
    a = Address.new( user_id: user_id,
                     street_address: Faker::Address.street_address,
                     city_id: City.select(:id).sample.id,
                     state_id: State.select(:id).sample.id,
                     zip_code: Faker::Address.zip.to_i)
    a.save! #just to check if anything fails here
  end
end


# decaying creation date
def creation_date
  time_frames = []
  (MULTIPLIER**2).times do |x|
    time_frames << Time.now - ((x*3) + 1).month
  end
  date_range = (time_frames.sample..Time.now)
  rand(date_range)
end



# create users
(MULTIPLIER * 10).times do
  sample_name = [Faker::Name.first_name, Faker::Name.last_name]


  u = User.new
  u[:first_name]  = sample_name[0]
  u[:last_name]   = sample_name[1]
  u[:email]       = Faker::Internet.email(sample_name.join(" "))
  u[:created_at]  = creation_date
  u.save

  # add in billing addresses
  generate_addresses(u.id)
  u[:billing_id]  = random_user_address(u.id)
  u[:shipping_id] = random_user_address(u.id)
  u.save
end

#generate order contents
def generate_contents(order_id)
  (rand(10)+1).times do
    c = OrderContents.new()
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




# a user can only have a single shopping cart
# that cart is the SINGLE order without a checkout_date
# a user can only have one such order

#  #present? is a Rails method that's the opposite of #empty?
def has_cart?(user_id)
  Order.where("user_id = ? AND checkout_date IS NULL ", user_id).present?
end

# when was this order placed?
def placement_date(user)
  rand(user[:created_at]..Time.now)
end



# FINALLY MAKE ORDERS
(MULTIPLIER* 30).times do
  # grab all extant IDs, sample them for one, then get the id number
  # out of the ActiveRecord relation that is returned.
  sample_id = User.select(:id).sample.id
  sample_user = User.find(sample_id)

  # 2 kinds of users can have orders built
  # a user with a billing address is one
  # a user who still needs a shopping cart built is the other
  if sample_user[:billing_id] || !has_cart?(sample_user[:id])
    o = Order.new()
    o[:user_id]        = sample_user.id
    o[:shipping_id]   = random_user_address(sample_user.id)
    o[:billing_id]    = random_user_address(sample_user.id)

    # first generated order is a shopping cart
    # all since then are placed orders with checkout dates
    if has_cart?(sample_user.id)
      o[:checkout_date] = placement_date(sample_user)
    end

    o.save
    generate_contents(o[:id])
  end
end


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