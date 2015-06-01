class City < ActiveRecord::Base
  has_many :addresses
  belongs_to :state
end
