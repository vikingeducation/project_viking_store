class User < ActiveRecord::Base
  # has_many :addresses, :orders
  # belongs_to :billing_id, , :class_name => "Address"
  # belongs_to :shipping_id, , :class_name => "Address"

  def self.user_created_days_ago(num_days)
    self.where("created_at > ?",Time.now - num_days.day).count
  end

  def self.top_3_cities
    self.joins("JOIN addresses ON addresses.user_id=users.id").joins("JOIN cities ON cities.id=addresses.city_id").select("cities.name, count(*) AS count ").group("cities.name").order(:count).reverse_order.limit(3)

  end
    

end
