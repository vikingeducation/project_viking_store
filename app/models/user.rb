class User < ApplicationRecord

  def get_new_user_count(n_of_days)
    User.where("created_at > NOW() - INTERVAL '? days'", n_of_days).count
  end

end
