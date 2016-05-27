class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state
  belongs_to :user
  has_many :orders, :foreign_key => :shipping_id

  validates :street_address, :city_id, :state_id, :presence => true
  # validates :state_id, :inclusion => {in: State.ids}
  validates :street_address, length: {in: (1..64)}
  # validates :user_id, :inclusion => {in: User.ids}

end
