FactoryBot.define do
  factory :booking do
    status { :pending }
    booking_date { Time.current }
    
    association :flight
    association :user

    trait :confirmed do
      status { :confirmed }
    end

    trait :cancelled do
      status { :cancelled }
    end

    trait :checked_in do
      status { :checked_in }
    end
  end
end
