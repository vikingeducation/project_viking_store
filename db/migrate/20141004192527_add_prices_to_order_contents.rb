class AddPricesToOrderContents < ActiveRecord::Migration
  def change
  	change_table :order_contents do |o|
  		o.decimal :current_price
  	end
  end
end
