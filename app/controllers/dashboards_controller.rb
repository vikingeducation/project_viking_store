class DashboardsController < ApplicationController
  def index
    @overall_analysis = overall_analysis
  end

  private

  def overall_analysis
    [7.days.ago, 30.days.ago, Time.at(0)].map do |date|
      PlatformAnalysis.new(from_day: date)
    end
  end
end
