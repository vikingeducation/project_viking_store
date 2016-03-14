class State < ActiveRecord::Base
  has_many :addresses

  def self.top_three_states
    # Trying to find via find_by_sql
    # First I needed a subquery table that got me all the distinct user_ids and one billing_id attached to each.
    # Then I joined it with the addresses table and the states tables.
    # I did a GOUP BY states.name so that I could get a count of each state
    # Then I ordered the aggregate 'count(*)' of those states descending
    # Then I sorted those descending
    # Then I got the top 3.
    # Use this method by:
    # ...first.name #=> 'Texas'  ...first.total #=> 4
    State.find_by_sql("SELECT states.name, COUNT(*) as total FROM (SELECT user_id, MAX(billing_id) as billing_id FROM orders GROUP BY user_id) AS a JOIN addresses ON a.billing_id=addresses.id JOIN states ON addresses.state_id=states.id GROUP BY states.name ORDER BY total DESC LIMIT 3")
  end
end
