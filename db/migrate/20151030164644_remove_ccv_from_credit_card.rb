class RemoveCcvFromCreditCard < ActiveRecord::Migration
  def change
    remove_column :credit_cards, :ccv
  end
end
