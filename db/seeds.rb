# Make sure your seeds file blows away any existing models every time it starts running: JUST RUN THIS WITH RAKE db:reset

#SCALAR == 5 => 155 Cities, 125 Users, <125 Orders, ~360 order items
puts "********Begin Seeding Data************"
t = Time.now
SCALAR = 5 # Seed multiplier

#generate products
SCALAR.times do
  Category.new( {
    name:        Faker::Commerce.department(1),
    description: Faker::Lorem.sentence
  } ).save
end

(SCALAR*10).times do
  Product.new( {
    name:        Faker::Commerce.product_name,
    category_id: rand(Category.count)+1,
    description: Faker::Lorem.sentence,
    sku:         (Faker::Code.ean).to_i,
    price:       Faker::Commerce.price
  } ).save
end

#generate addresses, SCALAR*31 cities
states =
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

states.each do |state|
  State.new({:name => state}).save
end

def sample_city # generates a new city/state/zip combination
  city = City.new({:name => Faker::Address.city})
  city.save
  { "city" => city.id,
    "state" => (rand(50)+1),
    "zip" => (Faker::Address.zip_code).to_i }
end

def sample_cities # appends city/state/zip combinations to three echelons in an array, with more instances for each successive echelon
  cities, towns, villages = [], [], []
  SCALAR.times do
    cities << sample_city
    5.times do
      towns << sample_city
      5.times do
        villages << sample_city
      end
    end
  end
  [cities, towns, villages]
end

SAMPLECITIES = sample_cities # so that the method is only run once

def random_user_address(user_id)
  address_choices = (Address.select(:id).where(:user_id => user_id)).to_a
  address_choices[0] ? address_choices.sample[:id] : nil
end

def city_sampling
  SAMPLECITIES.sample.sample
end

def generate_addresses(user_id)
  (rand(6)).times do
    city_instance = city_sampling
    Address.new( {
      user_id:        user_id,
      street_address: Faker::Address.street_address,
      city_id:        city_instance["city"],
      state_id:       city_instance["state"],
      zip_code:       city_instance["zip"],
      phone_number:   Faker::PhoneNumber.phone_number
    } ).save!
  end
end

#generate credit cards
def generate_card(user_id)
  CreditCard.new({
    user_id:      user_id,
    card_number:  Faker::Business.credit_card_number,
    exp_month:    rand(12)+1,
    exp_year:     2014+rand(10),
    ccv:          Faker::Number.number(3)
  }).save
end

#generate users, SCALAR*25 users
def creation_date
  time_frames = []
  SCALAR.times do |x|
    time_frames << Time.now - ((x+1)*3).month
  end
  date_range = (time_frames.sample..Time.now)
  rand(date_range)
end

(SCALAR*25).times do |x|
  sample_name = [Faker::Name.first_name, Faker::Name.last_name]
  generate_card(x+1)

  u = User.new( {
    first_name:  sample_name[0],
    last_name:   sample_name[1],
    email:       Faker::Internet.email(sample_name.join(" ")),
    created_at:  creation_date,
    phone_number:   Faker::PhoneNumber.phone_number
  } )
  u.save

  generate_addresses(x+1)

  u[:billing_id]  = random_user_address(x+1)
  u[:shipping_id] = random_user_address(x+1)
  u.save
end

#generate order contents
def generate_contents(order_id)
  (rand(10)+1).times do
    Purchase.new( {
      order_id:   order_id,
      product_id: rand(Product.count)+1,
      quantity:   rand(10)+1
    } ).save
  end
end

#generate orders; up to SCALAR*25 orders
def no_cart?(user_id)
  Order.where(:checked_out => false, :user_id => user_id).empty?
end

def completion(user)
  if no_cart?(user[:id])
    rand(5) > 0 && ! user[:billing_id].nil?
  else
    true
  end
end

def placement_date(user)
  rand(user[:created_at]..Time.now)
end

(SCALAR*25).times do
  sample_user = User.find(rand(User.count)+1)
  if sample_user[:billing_id] || no_cart?(sample_user[:id])
    completed_order = completion(sample_user)
    o = Order.new( {
      user_id:       sample_user.id,
      shipping_id:   random_user_address(sample_user.id),
      billing_id:    random_user_address(sample_user.id),
      checked_out:   completed_order,
      checkout_date: (placement_date(sample_user) if completed_order)
    } )
    o.save
    generate_contents(o[:id])
  end
end

q = Time.now
puts "********Seeding Data End************"
puts"********Seeding took #{q-t} seconds, I think************"