module CountSince

  extend ActiveSupport::Concern

  class_methods do

    def count_since(date)
      self.where('created_at >= ?', date).count
    end

  end


end
