class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :city, class_name: "City", foreign_key: :city_id
  belongs_to :state, class_name: "State", foreign_key: :state_id

  has_many :billed_orders, class_name: "Order", foreign_key: :billing_id
  has_many :shipped_orders, class_name: "Order", foreign_key: :shipping_id

  def self.get_all_for_user(n)
    Address.select("addresses.*, c.name AS city, s.name AS state")
      .joins("JOIN users u ON addresses.user_id=u.id")
      .joins("JOIN cities c ON c.id=addresses.city_id")
      .joins("JOIN states s ON s.id=addresses.state_id")
      .where("u.id=#{n}")
  end

end
