class EnableUlid < ActiveRecord::Migration[7.1]
  def change
    # Enable ULID for all future tables
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')
  end
end
