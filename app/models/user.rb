class User < ApplicationRecord

  def self.get_new_user_count(n_of_days = nil)
    return total_user_count unless n_of_days

    User.where("created_at > NOW() - INTERVAL '? days'",
                n_of_days).count
  end

  def self.total_user_count
    User.count
  end
end
