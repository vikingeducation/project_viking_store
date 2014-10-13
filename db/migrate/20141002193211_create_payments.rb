class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :user_id
      t.integer :cc_number
      t.integer :exp_month
      t.integer :exp_year
      t.integer :ccv




      t.timestamps
    end
  end
end
