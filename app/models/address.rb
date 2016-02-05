class Address < ActiveRecord::Base
  belongs_to :user
  belongs_to :state
  belongs_to :city
end
