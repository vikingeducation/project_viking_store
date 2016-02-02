module Recentable
  extend ActiveSupport::Concern

  module ClassMethods
    def recent(num_days = 7)
      self.where("#{self.table_name}.created_at >= ? ", num_days.days.ago.beginning_of_day)
    end
  end
end
