module Admin::UsersHelper

  def user_state(user_id)
    State.select(:name).joins(:addresses).where("addresses.user_id" => user_id).first
  end

  def user_city(user_id)
    City.select(:name).joins(:addresses).where("addresses.user_id" => user_id).first
  end

end
