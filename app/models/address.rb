class Address < ActiveRecord::Base
  belongs_to :city
  belongs_to :state
  belongs_to :user
  has_many :orders, :foreign_key => :shipping_id


  validates :street_address, :city_id, :state_id, :zip_code, :presence => true

  # validates :state_id, :inclusion => {in: State.ids}
  validates :city_id, :inclusion => {in: City.ids}, 
                      :numericality => true
  validates :street_address, length: {in: (1..255)}
  # validates :user_id, :inclusion => {in: User.ids}


end
