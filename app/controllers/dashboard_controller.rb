class DashboardController < ApplicationController

    def show
      @top_3 = User.top_3
      @ctop_3 = User.ctop_3
      @top_1_buyer = User.top_onetime_buyer
      @top_o_buyer = User.top_overall_buyer
      @top_a_buyer = User.top_avg_buyer
      @top_m_buyer = User.top_most_buyer
    end

end
