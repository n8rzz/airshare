FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    admin { false }

    trait :admin do
      admin { true }
    end

    trait :pilot do
      transient do
        pilot_capability { Capability.find_or_create_by!(name: 'pilot') }
      end

      after(:build) do |user, evaluator|
        user.capabilities << evaluator.pilot_capability
      end
    end

    trait :passenger do
      transient do
        passenger_capability { Capability.find_or_create_by!(name: 'passenger') }
      end

      after(:build) do |user, evaluator|
        user.capabilities << evaluator.passenger_capability
      end
    end
  end
end 