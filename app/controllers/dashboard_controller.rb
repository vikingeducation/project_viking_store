class DashboardController < ApplicationController
  include DashboardHelper

  def index

    @one = {
      :total => one_total,
      :thirty_days => one_thirty_days,
      :seven_days => one_seven_days
    }

    @two = {
      :states => two_states,
      :cities => two_cities,
      :top_user_with => top_user_with
    }

    @three = {
      :total => three_total,
      :thirty_days => three_thirty_days,
      :seven_days => three_seven_days
    }
  end

end
