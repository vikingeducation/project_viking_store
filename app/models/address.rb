class Address < ActiveRecord::Base

  belongs_to :user
  belongs_to :city
  belongs_to :state

  has_many :orders, foreign_key: :shipping_id


  def citystate_name(city, state)
    city = City.find_or_create_by( name: city )
    self.city = city
    state = State.find_or_create_by( name: state )
    self.state = state
    self.save
  end

  def update_name(city, state)
    city = City.find_or_create_by( name: city )
    self.city = city
    state = State.find_or_create_by( name: state )
    self.state = state
  end
end
