class CreateCreditCards < ActiveRecord::Migration
  def change
    create_table :credit_cards do |t|

      t.string :nickname, default: "My Credit Card"
      t.integer :card_number, null: false, unique: true
      t.integer :exp_month, null: false
      t.integer :exp_year, null: false
      t.string :brand, null: false, default: "VISA"

      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
