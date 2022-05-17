FactoryBot.define do
  factory :location_item do 
    location_id {1}
    item_id {1}
    location_quantity { rand(5..20) }
  end

end


