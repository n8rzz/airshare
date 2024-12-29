class CreateAircraft < ActiveRecord::Migration[7.1]
  def change
    create_table :aircrafts do |t|
      t.string :registration, null: false
      t.string :model, null: false
      t.integer :capacity, null: false
      t.date :manufacture_date, null: false
      t.integer :range_nm, null: false  # Range in nautical miles
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :aircrafts, :registration, unique: true
  end
end 