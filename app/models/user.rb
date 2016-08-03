class User < ActiveRecord::Base

  def self.get_count(time = nil)
    return self.count if time.nil?
    days_ago = time.days.ago
    self.where("created_at > ?", days_ago).count
  end

end
