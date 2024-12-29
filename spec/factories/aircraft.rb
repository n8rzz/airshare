FactoryBot.define do
  factory :aircraft do
    sequence(:registration) { |n| "N#{1000 + n}" }  # US registration format
    model { "Cessna 172" }
    capacity { 4 }
    manufacture_date { Date.new(2020, 1, 1) }
    range_nm { 640 }  # Typical range for a Cessna 172

    after(:build) do |aircraft|
      pilot = create(:user, :pilot)
      aircraft.owner = pilot
    end

    trait :long_range do
      model { "Pilatus PC-12" }
      capacity { 9 }
      range_nm { 1800 }
    end

    trait :vintage do
      manufacture_date { Date.new(1975, 1, 1) }
      model { "Piper Cherokee" }
    end
  end
end 