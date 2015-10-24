class Product < ActiveRecord::Base

  def self.total_listed(period = nil)
    total = Product.select("COUNT(*) AS t")
    if period
      total = total.where( "created_at BETWEEN :start AND :finish",
                          { start: DateTime.now - period, finish: DateTime.now } )
    end
    total.to_a.first.t
  end

end
