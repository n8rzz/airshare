FactoryBot.define do
  factory :flight do
    origin { "KSFO" }  # San Francisco International
    destination { "KJFK" }  # John F. Kennedy International
    departure_time { 1.day.from_now }
    estimated_arrival_time { departure_time + 6.hours }
    status { :scheduled }
    capacity { 100 }
    
    association :pilot, factory: [:user, :pilot]
    association :aircraft, capacity: 150  # Ensure aircraft capacity is greater than flight capacity

    trait :future do
      departure_time { 1.day.from_now }
      estimated_arrival_time { departure_time + 6.hours }
    end

    trait :past do
      departure_time { 1.day.ago }
      estimated_arrival_time { departure_time + 6.hours }

      after(:build) do |flight|
        flight.save(validate: false) if flight.new_record?
      end
    end

    trait :in_air do
      status { :in_air }
      actual_departure_time { 2.hours.ago }
    end

    trait :completed do
      status { :completed }
      actual_departure_time { 6.hours.ago }
      actual_arrival_time { 1.hour.ago }
    end

    trait :cancelled do
      status { :cancelled }
    end
  end
end
