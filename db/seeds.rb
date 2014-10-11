

# Make sure your seeds file blows away any existing models every time it starts running: JUST RUN THIS WITH RAKE db:reset

#scalar 10 => about 1,000 Cities, 1,000 Users, <1,000 Orders

SCALAR = 10 # Seed multiplier; caution: exponential data increase

#generate products
sample_categories = []

SCALAR.times do
  sample_categories << Faker::Commerce.department
end

sample_categories.each do |name|
  category = Category.new()
  category[:name]        = name
  category[:description] = Faker::Lorem.sentence
  category.save
end

(SCALAR**2).times do
  p = Product.new()
  p[:name]        = Faker::Commerce.product_name
  p[:category_id] = rand(Category.count)+1
  p[:description] = Faker::Lorem.sentence
  p[:sku]         = (Faker::Code.ean).to_i
  p[:price]       = Faker::Commerce.price
  p.save
end
 
#generate addresses, SCALAR*111 cities
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
  state = State.new({:name => state})
  state.save
end

def sample_city # generates a new city/state/zip combination
  city = City.new({:name => Faker::Address.city})
  if city.save
    {"city" => city.id, "state" => (rand(50)+1), "zip" => (Faker::Address.zip_code).to_i}
  else #sometimes the city already exists because we double up on a name
    {"city" => rand(City.count), "state" => (rand(50) + 1), "zip" => (Faker::Address.zip_code).to_i}
  end
end

def sample_cities # appends city/state/zip combinations to three echelons in an array, with more instances for each successive echelon
  cities, towns, villages = [], [], []
  SCALAR.times do
    cities << sample_city
    10.times do
      towns << sample_city
      10.times do
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
    a = Address.new()
    a[:user_id] = user_id
    a[:street_address] = Faker::Address.street_address
    a[:city_id] = city_instance["city"]
    a[:state_id] = city_instance["state"]
    a[:zip_code] = city_instance["zip"]
    a[:phone_number] = Faker::PhoneNumber.phone_number
    if a[:city_id] == nil
      puts "****/\n\n\n a:#{a}\n\ncity-instance:#{city_instance}\n\n********" 
      p Address.all
    end
    a.save
  end
end
 
#generate users, SCALAR**2 users
def creation_date
  time_frames = []
  SCALAR.times do |x|
    time_frames << Time.now - ((x+1)*3).month
  end
  date_range = (time_frames.sample..Time.now)
  rand(date_range)
end

(SCALAR**3).times do |x|
  sample_name = [Faker::Name.first_name, Faker::Name.last_name]
  generate_addresses(x+1)

  u = User.new()
  u[:first_name]  = sample_name[0]
  u[:last_name]   = sample_name[1]
  u[:email]       = Faker::Internet.email(sample_name.join(" "))
  u[:billing_id]  = random_user_address(x+1)
  u[:shipping_id] = random_user_address(x+1)
  u[:created_at]  = creation_date

  u.save
end

#generate order contents
def generate_contents(order_id)
  (rand(10)+1).times do
    c = Purchase.new()
    c[:order_id]   = order_id
    c[:product_id] = rand(Product.count)+1
    c[:quantity]   = rand(10)+1
    c.save
  end
end

#generate orders
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

(SCALAR**3).times do
  sample_user = User.find(rand(User.count)+1)
  if sample_user[:billing_id] || no_cart?(sample_user[:id])
    completed_order = completion(sample_user)
    o = Order.new()
    o[:user_id]        = sample_user.id
    o[:shipping_id]   = random_user_address(sample_user.id)
    o[:billing_id]    = random_user_address(sample_user.id)
    o[:checked_out]   = completed_order
    o[:checkout_date] = placement_date(sample_user) if completed_order
    o.save
    generate_contents(o[:id])
  end
end

users_with_orders = Order.all.select("DISTINCT user_id")

users_with_orders.each do |user|
  card = CreditCard.new
  card[:user_id] = user.user_id
  card[:card_number] = Faker::Business.credit_card_number
  card[:exp_month] = rand(12) + 1
  card[:exp_year] = Time.now.year + rand(5) #so far, only good cards
  card[:brand] = ['VISA', 'MasterCard', 'Discover', 'Amex'].sample
  card.save
end
