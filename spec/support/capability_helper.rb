module CapabilityHelper
  def ensure_capabilities_exist
    %w[pilot passenger].each do |name|
      Capability.find_or_create_by!(name: name)
    end
  end
end

RSpec.configure do |config|
  config.include CapabilityHelper
end 