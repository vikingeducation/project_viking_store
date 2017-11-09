module Dateable
  def from(start_date, column = :created_at)
    unless start_date.respond_to?(:to_time)
      raise ArgumentError, "#{start_date} does not response to #{to_time}"
    end
    
    where("#{column}" => start_date..Time.now)
  end
end
