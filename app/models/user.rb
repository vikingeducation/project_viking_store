class User < ActiveRecord::Base

  def self.get_count(time = nil)
    self.count if time.nil?
  end

end
