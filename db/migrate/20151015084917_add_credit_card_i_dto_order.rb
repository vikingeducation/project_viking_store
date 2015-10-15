class AddCreditCardIDtoOrder < ActiveRecord::Migration
  def change
    add_column :orders, :billing_card_id, :integer
  end
end
