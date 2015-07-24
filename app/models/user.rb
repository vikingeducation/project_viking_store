class User < ActiveRecord::Base

def self.new_users(input_day)
	self.where("created_at > ?", input_day.days.ago).count
end


end
