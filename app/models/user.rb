class User < ActiveRecord::Base
  scope :last_seven_days, -> { get_created_at(7.days.ago) }
  scope :last_thirty_days, -> { get_created_at(30.days.ago) }

  class << self

    private
      def get_created_at(time)
        where("created_at <= ?", time).count
      end

  end

end
