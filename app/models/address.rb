class Address < ActiveRecord::Base
  belongs_to :state
  belongs_to :city
  belongs_to :created_by_user, :class_name => 'User', :foreign_key => :user_id

  has_many :default_billing_users, :class_name => 'User', :foreign_key => :billing_id
  has_many :default_shipping_users, :class_name => 'User', :foreign_key => :shipping_id

  has_many :billed_orders, :class_name => 'Order', :foreign_key => :billing_id
  has_many :shipped_orders, :class_name => 'Order', :foreign_key => :shipping_id


# Portal methods
  def stringify
    "#{self.street_address}, #{self.city.name}, #{self.state.name}" || "No saved address"
  end


  def id_and_address
    "#{id} (#{street_address})"
  end

end
