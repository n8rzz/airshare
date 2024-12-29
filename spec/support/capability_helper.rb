module CapabilityHelper
  def ensure_capabilities_exist
    Capability.find_or_create_by!(name: 'pilot')
    Capability.find_or_create_by!(name: 'passenger')
  end
end

RSpec.configure do |config|
  config.include CapabilityHelper
  
  config.before(:suite) do
    Capability.find_or_create_by!(name: 'pilot')
    Capability.find_or_create_by!(name: 'passenger')
  end
end 