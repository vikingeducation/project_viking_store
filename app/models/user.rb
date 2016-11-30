class User < ApplicationRecord

  def self.count_by_days(num_days)
    users = select('COUNT(*) AS u_count')
    users = users.where("created_at >= ?", num_days.days.ago) if num_days
    users[0].u_count
  end

  def self.count_by_demo(demographic, sort: "DESC", addr_type: "billing", limit: nil)
    plural = demographic.pluralize
    users = select("#{plural}.name AS name, COUNT(users.id) AS user_count")
                 .joins("JOIN addresses ON (addresses.id = users.#{addr_type}_id)")
                 .joins("JOIN #{plural} ON (#{plural}.id = addresses.#{demographic}_id)")
                 .group("#{plural}.name")
                 .order("COUNT(users.id) #{sort}")
    users.limit(limit) if limit

  end
end
