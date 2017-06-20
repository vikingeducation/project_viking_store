class State < ApplicationRecord


  has_many :addresses

  #wildly over the top
  validates :name, presence: true,
            inclusion: ["Alabama", "Alaska", "Arizona", "Arkansas", "California","Colorado", "Connecticut", "Delaware", "Florida", "Georgia","Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio","Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont","Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]

  # JOINs the states to addresses and addresses to users, GROUPs the rows by state name, ORDERs them by user count, LIMITs the table to the first three records, and then SELECTs the state name and user count. The returned object has #state_name and #users_in_state methods.
  def self.three_with_most_users
    select("states.name AS state_name, COUNT(*) AS users_in_state").
      joins("JOIN addresses ON states.id = addresses.state_id JOIN users ON users.billing_id = addresses.id").
      order("users_in_state DESC").
      group("states.name").
      limit(3)
  end
end
