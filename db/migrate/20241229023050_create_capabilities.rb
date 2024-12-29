class CreateCapabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :capabilities do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :capabilities, :name, unique: true
  end
end
