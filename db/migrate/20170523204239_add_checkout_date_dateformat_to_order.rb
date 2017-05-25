class AddCheckoutDateDateformatToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :checkout_date_dateformat, :date
  end
end
