class Category < ActiveRecord::Base
validates :name, 
          :presence => true,
          :length => {:within => 4..16}
validates :id, :presence => true

def initial_table

  @table_data = Category.joins("JOIN products ON users.billing_id = addresses.id").joins("JOIN states ON states.id = addresses.state_id").select("states.name, count(*) AS count")


end

def get_prices

end


end
