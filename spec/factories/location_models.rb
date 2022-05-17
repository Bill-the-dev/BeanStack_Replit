FactoryBot.define do
  factory :location do
    city { Faker::Address.unique.city }
    state { 'CA' }
    country { 'US' }
    zip { Faker::Address.unique.zip_code(state_abbreviation: 'CA') }
    weather { '' }
  end
end

# Faker::UniqueGenerator.clear # Clears used values for all generators