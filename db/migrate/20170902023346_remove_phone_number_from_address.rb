class RemovePhoneNumberFromAddress < ActiveRecord::Migration[5.1]
  def change
    remove_column :addresses, :phone_number
  end
end
