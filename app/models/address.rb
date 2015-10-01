class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state
  belongs_to :user

  validates :street_address,
            :presence => true,
            :length => {
              :maximum => 64
            }

  validates :zip_code,
            :presence => true

  validates :city,
            :presence => true

  validates :state,
            :presence => true

  validates :user,
            :presence => true
end
