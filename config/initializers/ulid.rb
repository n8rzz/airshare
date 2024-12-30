# Configure Rails to use string IDs by default for new tables
Rails.application.config.generators do |g|
  g.orm :active_record, primary_key_type: :string
end

# Configure Active Record to generate ULIDs
module UlidPrimaryKey
  extend ActiveSupport::Concern

  included do
    before_create :generate_ulid_id
  end

  private

  def generate_ulid_id
    self.id ||= ULID.generate
  end
end

# Include ULID generation in all models
ActiveRecord::Base.include UlidPrimaryKey 