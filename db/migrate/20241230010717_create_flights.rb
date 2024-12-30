class CreateFlights < ActiveRecord::Migration[7.1]
  def change
    create_table :flights do |t|
      t.string :origin
      t.string :destination
      t.datetime :departure_time
      t.datetime :estimated_arrival_time
      t.datetime :actual_departure_time
      t.datetime :actual_arrival_time
      t.integer :status
      t.integer :capacity
      t.references :pilot, null: false, foreign_key: { to_table: :users }
      t.references :aircraft, null: false, foreign_key: true

      t.timestamps
    end
  end
end
