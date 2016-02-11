class State < ActiveRecord::Base
  has_many :addresses
  has_many :users, through: :addresses
end
