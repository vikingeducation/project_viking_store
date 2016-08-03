class Product < ActiveRecord::Base
  scope :last_seven_days, -> { where("created_at <= ?", 7.days.ago).count }
  scope :revenue_last_seven_days, -> { get_revenue(7.days.ago) }

  class << self
    
    private

      def get_revenue(time)
        Product.where("created_at <= ?", time).sum(:price)
      end

  end

end
