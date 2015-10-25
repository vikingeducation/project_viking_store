class DashboardController < ApplicationController

  def home
    begin_time = Time.now
    d = Dashboard.new
    @top_panels = d.top_panels
    @bottom_panels = d.bottom_panels
    end_time = Time.now
    @benchmark = end_time - begin_time
  end


end
