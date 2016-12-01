class TimeSeries
  def self.data(interval = nil)
    val = []
    7.times do |i|
      val << [Order.count_by_days(i*interval + 1)]
    end
    val
  end
end
