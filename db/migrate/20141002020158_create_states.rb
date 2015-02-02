class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.string :name, null: false, index: true, unique: true

      t.timestamps
    end
  end
end
