class Order < ActiveRecord::Base
  scope :last_seven_days, -> { where("created_at <= ?", 7.days.ago).count }

  class << self

  end

end
