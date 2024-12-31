class AddPasswordResetTrackingToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :reset_password_attempts, :integer, default: 0
    add_column :users, :reset_password_attempted_at, :datetime
  end
end
