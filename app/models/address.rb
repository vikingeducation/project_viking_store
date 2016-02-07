class Address < ActiveRecord::Base
  has_many :billing_users,  class_name: "User",
                            foreign_key: :billing_id
  has_many :shipping_users, class_name: "User",
                            foreign_key: :shipping_id

  has_many :billing_orders,  class_name: "Order",
                            foreign_key: :billing_id
  has_many :shipping_orders, class_name: "Order",
                            foreign_key: :shipping_id

  belongs_to :user
  belongs_to :city
  belongs_to :state

  # after_create :make_or_save_city
  #
  # def make_or_save_city
  #
  # end

  # Virtual attribute
  # def city_name=(name)
  #   city = City.find_or_create_by( name: name )
  #   self.city = city
  #   self.save!
  # end
end
