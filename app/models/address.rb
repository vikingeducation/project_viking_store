class Address < ActiveRecord::Base
  belongs_to :user

  def state
    State.find(self.state_id)
  end

  def city
    City.find(self.city_id)
  end
end
