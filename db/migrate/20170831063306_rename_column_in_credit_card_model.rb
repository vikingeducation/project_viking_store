class RenameColumnInCreditCardModel < ActiveRecord::Migration[5.1]
  def change
    rename_column :credit_cards, :ccv, :cvv
  end
end
