class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :state
  belongs_to :city

  def self.get_user_address_info(uid=nil)
    if uid.nil?
      User.select("c.name AS city, s.name AS state, DATE(u.created_at) AS joined,
                   u.id, u.first_name, u.last_name AS last_name, a.id AS address_id,
                   a.street_address, COUNT(o.id) AS totals")
      .joins("AS u JOIN addresses AS a ON u.id = a.user_id")
      .joins("JOIN cities AS c ON c.id=a.city_id")
      .joins("JOIN states AS s ON s.id=a.state_id")
      .joins("LEFT JOIN orders AS o ON o.billing_id = a.id")
      .order("u.id").group("u.id,s.name,c.name,a.id")
    else
      User.select("c.name AS city, s.name AS state, DATE(u.created_at) AS joined,
                   u.id, u.first_name, u.last_name AS last_name, a.id AS address_id,
                   a.street_address, COUNT(o.id) AS totals")
      .joins("AS u JOIN addresses AS a ON u.id = a.user_id")
      .joins("JOIN cities AS c ON c.id=a.city_id")
      .joins("JOIN states AS s ON s.id=a.state_id")
      .joins("LEFT JOIN orders AS o ON o.billing_id = a.id")
      .order("u.id").group("u.id,s.name,c.name,a.id").where("u.id = #{uid}")
    end 
  end

  def self.get_detailed_address_info(address)

    address_info = {}
    address_info['city'] = address.city.name
    address_info['state'] = address.state.name
    address_info['address'] = address.street_address
    address_info['zip_code'] = address.zip_code
    address_info['id'] = address.id

    u = address.user

    address_info['fname'] = u.first_name
    address_info['lname'] = u.last_name
    address_info['user_id'] = u.id

    address_info
    
  end

end 
