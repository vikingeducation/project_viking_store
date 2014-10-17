class AddPhoneNumbertoAddress < ActiveRecord::Migration
  def up
    add_column :addresses, :phone_number, :string
  end

  def down
    remove_column :addresses, :phone_number
  end
end
