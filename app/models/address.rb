class Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :city
  belongs_to :created_by_user, :class_name => 'User', :foreign_key => :user_id

  has_many :default_billing_users, :class_name => 'User', :foreign_key => :billing_id
  has_many :default_shipping_users, :class_name => 'User', :foreign_key => :shipping_id

  has_many :billed_orders, :class_name => 'Order', :foreign_key => :billing_id
  has_many :shipped_orders, :class_name => 'Order', :foreign_key => :shipping_id


# Portal methods
  def self.get_index_data(user_id = nil)

    if user_id.nil?
      addresses = Address.order(:id).all
    else
      addresses = Address.order(:id).where(:user_id => user_id)
    end

    output = []

    addresses.each do |address|
      output << {
                  :relation => address,
                  :user => address.created_by_user,
                  :city_name => address.city.name,
                  :state_name => address.state.name,
                  :order_count => address.get_order_count
                }
    end

    output

  end


  def get_order_count
    self.billed_orders.where("checkout_date IS NOT NULL").count
  end


  def stringify
    "#{self.street_address}, #{self.city.name}, #{self.state.name}" || "No saved address"
  end


  def id_and_address
    "#{id} (#{street_address})"
  end

end
