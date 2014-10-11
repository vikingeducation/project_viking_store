class ChangePricesToFloatOrderContents < ActiveRecord::Migration
  def up
  	change_table :order_contents do |o|
  		o.change :current_price, :float
  	end
  end
end
