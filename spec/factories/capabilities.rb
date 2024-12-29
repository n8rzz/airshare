FactoryBot.define do
  factory :capability do
    sequence(:name) { |n| ['pilot', 'passenger'][n % 2] }

    trait :pilot do
      name { 'pilot' }
    end

    trait :passenger do
      name { 'passenger' }
    end
  end

  factory :user_capability do
    user
    capability
  end
end 