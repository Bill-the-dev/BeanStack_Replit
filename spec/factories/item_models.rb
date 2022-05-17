FactoryBot.define do
  factory :item do
    # association :Location
    name { Faker::Coffee.blend_name }
    vendor { Faker::Coffee.origin }
    # quantity { sum of LocationItems @ all locations }
    price { rand(5.00..20.99).round(2).to_f }
    description { Faker::Coffee.notes }
    category { Faker::Coffee.variety }
    user_id { 1 }
  end

  # factory :location do 
  #   city { Faker::Address.city }
  #   state { Faker::Address.state_abbr }
  #   country { Faker::Address.country_by_code(code: 'NL') }
  #   zip { Faker::Address.zip }
  #   weather { '' }
  # end

  # factory :location_item do
  #   item
  #   location
  # end

end

# def item_with_location(location_count: 2)
#   FactoryBot.create(:location) do |location|
#     FactoryBot.create_list(:item, item_count, location: location)
#   end
# end