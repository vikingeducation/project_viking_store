class FixCreditCards < ActiveRecord::Migration
  def up
    add_column :credit_cards, :ccv, :string
    change_column :credit_cards, :card_number, :string
  end

  def down
    remove_column :credit_cards, :ccv
    change_column :credit_cards, :card_number, :integer
  end
end
