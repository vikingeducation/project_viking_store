class AdminController < ApplicationController

  def new
    @users = User.user_data.limit(9)

    @last_date = {}

    @users.each do |user|
      @last_date[user.id] = User.last_order_date(user.id)
    end
  end
end
