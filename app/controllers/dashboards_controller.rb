class DashboardsController < ApplicationController
  def index
    @platform_analysis = platform_analysis
  end

  private

  def platform_analysis
    [7.days.ago, 30.days.ago, Time.at(0)].map do |date|
      PlatformAnalysis.new(from_day: date)
    end
  end
end
