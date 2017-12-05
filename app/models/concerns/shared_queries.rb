module SharedQueries

  extend ActiveSupport::Concern

  class_methods do

    def last_n_days(n)
      past = Date.today - n.days
      where("created_at > ?", past)
    end

  end
end
