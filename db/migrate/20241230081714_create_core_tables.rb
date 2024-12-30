class CreateCoreTables < ActiveRecord::Migration[7.1]
  def change
    create_table :users, id: :string, limit: 26 do |t|
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.boolean :admin, null: false, default: false
      t.string :provider
      t.string :uid
      t.string :name
      t.string :avatar_url
      t.integer :sign_in_count
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.integer :capabilities_count, null: false, default: 0

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, [:provider, :uid]
    add_index :users, :admin

    create_table :capabilities, id: :string, limit: 26 do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :capabilities, :name, unique: true

    create_table :aircrafts, id: :string, limit: 26 do |t|
      t.string :registration, null: false
      t.string :model, null: false
      t.integer :capacity, null: false
      t.date :manufacture_date, null: false
      t.integer :range_nm, null: false
      t.string :owner_id, null: false, limit: 26

      t.timestamps
    end

    add_index :aircrafts, :owner_id
    add_index :aircrafts, :registration, unique: true
    add_foreign_key :aircrafts, :users, column: :owner_id

    create_table :flights, id: :string, limit: 26 do |t|
      t.string :origin
      t.string :destination
      t.datetime :departure_time
      t.datetime :estimated_arrival_time
      t.datetime :actual_departure_time
      t.datetime :actual_arrival_time
      t.integer :status
      t.integer :capacity
      t.string :pilot_id, null: false, limit: 26
      t.string :aircraft_id, null: false, limit: 26

      t.timestamps
    end

    add_index :flights, :pilot_id
    add_index :flights, :aircraft_id
    add_foreign_key :flights, :users, column: :pilot_id
    add_foreign_key :flights, :aircrafts

    create_table :bookings, id: :string, limit: 26 do |t|
      t.integer :status
      t.datetime :booking_date
      t.string :flight_id, null: false, limit: 26
      t.string :user_id, null: false, limit: 26
      t.text :notes

      t.timestamps
    end

    add_index :bookings, :flight_id
    add_index :bookings, :user_id
    add_foreign_key :bookings, :flights
    add_foreign_key :bookings, :users

    create_table :user_capabilities, id: :string, limit: 26 do |t|
      t.string :user_id, null: false, limit: 26
      t.string :capability_id, null: false, limit: 26

      t.timestamps
    end

    add_index :user_capabilities, :user_id
    add_index :user_capabilities, :capability_id
    add_index :user_capabilities, [:user_id, :capability_id], unique: true
    add_foreign_key :user_capabilities, :users
    add_foreign_key :user_capabilities, :capabilities
  end
end
