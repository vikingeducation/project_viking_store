class UserDemographics

  def self.location_demo(location)

    # select count of user
    # joined on addresses table by billing id
    # joined on state table by state id
    # group by state
    # order by count of state desc
    # limit 3

    plural_location = pluralize(location)

    locations = User.select("#{plural_location}.name AS name, COUNT(users.id) AS user_count")
                 .joins('JOIN addresses ON (addresses.id = billing_id')
                 .joins("JOIN #{plural_location} ON (#{plural_location}.id = #{location}_id")
                 .group("#{plural_location}.name")
                 .order('COUNT(users.id)', :desc)
                 .limit(3)

    locations.map do |row|
      [ row.name, row.user_count]
    end

  end

end