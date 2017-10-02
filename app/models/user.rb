class User < ApplicationRecord
  scope :signed_up_since, ->(begin_date) {
    where('created_at > ? AND created_at < ?', begin_date, Time.zone.now)
  }

  def self.signed_up_in_last(num_days)
    begin_date = eval("#{num_days}.days.ago")
    signed_up_since(begin_date)
  end
end
