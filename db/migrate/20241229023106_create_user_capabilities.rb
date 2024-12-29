class CreateUserCapabilities < ActiveRecord::Migration[7.1]
  def change
    create_table :user_capabilities do |t|
      t.references :user, null: false, foreign_key: true
      t.references :capability, null: false, foreign_key: true

      t.timestamps
    end

    add_index :user_capabilities, [:user_id, :capability_id], unique: true
  end
end
