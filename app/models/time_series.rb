class TimeSeries
  include ActionView::Helpers::DateHelper
  def self.data(interval = nil)
    val = []
    7.times do |i|
      val <<  [
                ((i+1)*interval).days.ago,
                Order.count_by_days((i+1)*interval, i*interval),
                Order.revenue((i+1)*interval, i*interval)
              ]
    end
    val
  end
end
