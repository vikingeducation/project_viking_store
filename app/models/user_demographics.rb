class UserDemographics

  def self.location_demo(location)

    # select count of user
    # joined on addresses table by billing id
    # joined on state table by state id
    # group by state
    # order by count of state desc
    # limit 3

    plural = ActiveSupport::Inflector.pluralize(location)

    locations = User.select("#{plural}.name AS name, COUNT(users.id) AS user_count")
                 .joins('JOIN addresses ON (addresses.id = users.billing_id)')
                 .joins("JOIN #{plural} ON (#{plural}.id = addresses.#{location}_id)")
                 .group("#{plural}.name")
                 .order('COUNT(users.id) DESC')
                 .limit(3)

    locations.map do |row|
      [ row.name, row.user_count]
    end

  end

end
