class Address < ActiveRecord::Base

  validates :street_address, length: { maximum: 64 }, presence: true
  validates :zip_code, length: { is: 5 }, numericality: true, presence: true
  # validates :user_id, presence: true
  # validate :validate_user_exists

  belongs_to :user
  belongs_to :city
  belongs_to :state

  def validate_user_exists
    errors.add(:user_with_id, "ID #{self.user_id} does not exist.") unless User.exists?(self.user_id)
  end

  def full_address
    "#{self.street_address}, #{self.city.name}, #{self.state.name}"
  end

  def self.user_order(user_id)
    return all unless user_id
    where(user_id: user_id).order("created_at DESC")
  end
end
