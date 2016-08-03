class User < ActiveRecord::Base

	def self.total_users(date=nil)

		t = User.all
		unless date.nil?
			t.where("created_at > ?", date).count
		else
			t.count	
		end
	end



end
