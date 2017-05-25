class AddCcVtoCreditCard < ActiveRecord::Migration
  def change
    add_column :credit_cards, :ccv, :integer
  end
end
