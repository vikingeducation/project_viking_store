class MakeCreditCardsAString < ActiveRecord::Migration
  def change
    change_column :credit_cards, :card_number, :string
  end
end
