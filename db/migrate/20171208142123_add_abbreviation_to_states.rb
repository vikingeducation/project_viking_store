class AddAbbreviationToStates < ActiveRecord::Migration[5.0]
  def change
    add_column :states, :abbreviation, :string
  end
end
