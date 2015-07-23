# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

# MULTIPLIER is used to create a predictable ratio of records. For instance, we will have 10 Product records for every Category.
MULTIPLIER = 10


# A list of states.
STATES =  [
            ["AK", "Alaska"],
            ["AL", "Alabama"],
            ["AR", "Arkansas"],
            ["AS", "American Samoa"],
            ["AZ", "Arizona"],
            ["CA", "California"],
            ["CO", "Colorado"],
            ["CT", "Connecticut"],
            ["DC", "District of Columbia"],
            ["DE", "Delaware"],
            ["FL", "Florida"],
            ["GA", "Georgia"],
            ["GU", "Guam"],
            ["HI", "Hawaii"],
            ["IA", "Iowa"],
            ["ID", "Idaho"],
            ["IL", "Illinois"],
            ["IN", "Indiana"],
            ["KS", "Kansas"],
            ["KY", "Kentucky"],
            ["LA", "Louisiana"],
            ["MA", "Massachusetts"],
            ["MD", "Maryland"],
            ["ME", "Maine"],
            ["MI", "Michigan"],
            ["MN", "Minnesota"],
            ["MO", "Missouri"],
            ["MS", "Mississippi"],
            ["MT", "Montana"],
            ["NC", "North Carolina"],
            ["ND", "North Dakota"],
            ["NE", "Nebraska"],
            ["NH", "New Hampshire"],
            ["NJ", "New Jersey"],
            ["NM", "New Mexico"],
            ["NV", "Nevada"],
            ["NY", "New York"],
            ["OH", "Ohio"],
            ["OK", "Oklahoma"],
            ["OR", "Oregon"],
            ["PA", "Pennsylvania"],
            ["PR", "Puerto Rico"],
            ["RI", "Rhode Island"],
            ["SC", "South Carolina"],
            ["SD", "South Dakota"],
            ["TN", "Tennessee"],
            ["TX", "Texas"],
            ["UT", "Utah"],
            ["VA", "Virginia"],
            ["VI", "Virgin Islands"],
            ["VT", "Vermont"],
            ["WA", "Washington"],
            ["WI", "Wisconsin"],
            ["WV", "West Virginia"],
            ["WY", "Wyoming"]
          ]




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




# Because seeds.rb is run as a script, you'll need to put helper methods ABOVE where they are used to generate records.
# This file defines all the methods and data first, then runs all the procedural stuff at the end.

# Generate Category records for your Product records.
def generate_category
  category = Category.new
  category[:name]        = Faker::Commerce.department
  category[:description] = Faker::Lorem.sentence
  category.save
end

# Creates a random two-digit number between 0 and 100. You probably used Faker::Commerce.price, which is great, but that method doesn't let us seed the database and it gave us inconsistent pricing.
def random_price
  (rand(0..100.0) * 100).floor/100.0
end

# Generate Product records and assign them each to a random Category.
def generate_product
  p = Product.new
  p[:name]        = Faker::Commerce.product_name
  p[:category_id] = Category.pluck(:id).sample
  p[:description] = Faker::Lorem.sentence
  p[:sku]         = (Faker::Code.ean).to_i
  p[:price]       = random_price
  p.save
end


# state[0] to use abbreviation, state[1] to use name
def generate_state(state)
  state = State.new({:name => state[0]})
  state.save
end

# Generate some City records. Your Address model could have also included "city" as a string instead of a foreign key.
def generate_city
  City.create( :name => Faker::Address.city )
end

# This method selects one of a users several addresses for use setting shipping address and billing address.
def random_user_address(user_id)
  # User.find(user_id).addresses.sample[:id] ## had to correct with following line:
  User.joins("JOIN addresses ON users.id = addresses.user_id").pluck("addresses.id").sample
end

# This method creates a single address affiliated with a user.
def generate_address(user_id)
  a = Address.new
  a[:user_id] = user_id
  a[:street_address] = Faker::Address.street_address
  a[:city_id] = City.pluck(:id).sample
  a[:state_id] = State.pluck(:id).sample
  a[:zip_code] = Faker::Address.zip.to_i
  a.save! #just to check if anything fails here
end

# This method creates 1 to 4 addresses associated with a specific user.
def generate_addresses_for_user(user_id)
  (rand(4)+1).times do
    generate_address(user_id)
  end
end

# Returns the timestamp for midnight of the day the file is run.
# Corrected to use last night's midnight instead of a future midnight!
def midnight_tonight
  (Time.now.to_date + 0).to_time
end

# This method returns a date that's random but weighted toward the current date.
# I don't think this is weighted at all???
def creation_date
  time_frames = []
  (MULTIPLIER**2).times do |x|
     time_frames << midnight_tonight - ((x*3) + 1).month
  end
  date_range = (time_frames.sample..midnight_tonight)
  rand(date_range)
end

def generate_user
  first_name = Faker::Name.first_name
  last_name = Faker::Name.last_name

  u = User.new
  u[:first_name]  = first_name
  u[:last_name]   = last_name
  u[:email]       = Faker::Internet.email("#{first_name} #{last_name}")
  u[:created_at]  = creation_date
  u.save

  # Create affilliated addresses and select billing and shipping addresses.
  generate_addresses_for_user(u.id)
  u[:billing_id]  = random_user_address(u.id)
  u[:shipping_id] = random_user_address(u.id)
  u.save
end

# Here are some methods that will help us create Order records.

# This method adds random Product records to Orders through the OrderContents model.

def generate_contents(order_id)
  (rand(10) + 1).times do
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
  rand(user[:created_at]..midnight_tonight)
end

# Selects a user at random and gives them an order.
def generate_order
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
def generate_credit_cards_for_checked_out_orders
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
end



# This seeds the random number generator so the rest of this file behaves predictably. (This was definitely not part of your assignment.)
srand(42)


# Now, at last, we are going to run all these methods to create our data!

# Create states and cities
STATES.each { |state| generate_state state }
(MULTIPLIER * 10).times { generate_city }

# Create categories and products
 MULTIPLIER.times       { generate_category }
(MULTIPLIER * 10).times { generate_product }

# Create users
(MULTIPLIER * 10).times { generate_user }

# Create orders and add the credit card records.
(MULTIPLIER * 30).times { generate_order }
generate_credit_cards_for_checked_out_orders
