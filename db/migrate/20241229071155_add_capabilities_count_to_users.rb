class AddCapabilitiesCountToUsers < ActiveRecord::Migration[7.1]
  def up
    add_column :users, :capabilities_count, :integer, default: 0, null: false

    User.find_each do |user|
      User.reset_counters(user.id, :capabilities)
    end
  end

  def down
    remove_column :users, :capabilities_count
  end
end
