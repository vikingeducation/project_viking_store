class Address < ActiveRecord::Base
  def self.get_all_for_user(n)
    Address.select("addresses.*, c.name AS city, s.name AS state")
      .joins("JOIN users u ON addresses.user_id=u.id")
      .joins("JOIN cities c ON c.id=addresses.city_id")
      .joins("JOIN states s ON s.id=addresses.state_id")
      .where("u.id=#{n}")
  end
end
