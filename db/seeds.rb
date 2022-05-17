require "rest-client"
require "json"

# -- LOCATIONS --

new_york = Location.create(
  city: 'New York',
  state: 'NY',
  country: 'US',
  zip: '10018',
  weather: ''
)

chicago = Location.create(
  city: 'Chicago',
  state: 'IL',
  country: 'US',
  zip: '60657',
  weather: ''
)

ottawa = Location.create(
  city: 'Ottawa',
  state: 'ON',
  country: 'CA',
  zip: 'K2P',
  weather: ''
)

san_francisco = Location.create(
  city: 'San Francisco',
  state: 'CA',
  country: 'US',
  zip: '94105',
  weather: ''
)

denver = Location.create(
  city: 'Denver',
  state: 'CO',
  country: 'US',
  zip: '80205',
  weather: ''
)

# -- ITEMS --
25.times do 
  name = Faker::Coffee.blend_name
  vendor = Faker::Coffee.origin
  # quantity = sum of LocationItems @ all locations
  price = rand(5.00..20.99).round(2).to_f
  description = Faker::Coffee.notes
  category = Faker::Coffee.variety
  user_id = 1
  
  Item.create(
    name: name, 
    vendor: vendor, 
    # quantity: set below, 
    price: price,
    description: description, 
    category: category,
    user_id: user_id
  )
end

location_ids = Location.all.map { |location| location.id }
item_ids = Item.all.map { |item| item.id }

# Assumes seed inefficiency acceptable with arrays and nested iteration O(n^2), as it is only seeded once.

# -- LOCATION ITEMS --
location_ids.each do |loc_id|
  item_ids.each do |item_id|
    LocationItem.create(
      location: Location.find(loc_id),
      item: Item.find(item_id),
      location_quantity: rand(5..20)
    )
  end
end


def get_weather(loc_id, location)
  # replit req's alternate credentials
  # api_key = Rails.application.credentials.open_weather_api
  api_key = "929634c6b887f6227ff8635266438ca6"

  zip_weather_url = "https://api.openweathermap.org/data/2.5/weather?zip=#{location.zip},#{location.country}&units=imperial&appid=#{api_key}"
  res_weather = RestClient.get(zip_weather_url)
  data = JSON.parse(res_weather.body, object_class: OpenStruct)
  weather = { temp: data.main.temp.round(0), description: data.weather[0].description }
  return weather
end
  
# -- LOCATIONS WEATHER --
location_ids.each do |loc_id|
  location = Location.find(loc_id)
  weather_str = get_weather(loc_id, location)
  
  location.weather = weather_str
  location.save
end


# -- ITEMS TOTAL --
item_ids.each do |item_id|
  total = 0
  location_ids.each do |loc_id|
    item_count = LocationItem.where(location: loc_id, item: item_id).pluck(:location_quantity)[0]
    total += item_count
  end
  # set Item quantity to total
  item = Item.find(item_id)
  item.quantity = total
  item.save
end



  # t.string "name" # Faker::Coffee.blend_name #=> "Summer Solstice"
  # t.string "vendor" # Faker::Coffee.origin #=> "Antigua, Guatemala"
  # t.integer "quantity"
  # t.decimal "price"
  # t.text "description" # Faker::Coffee.notes #=> "balanced, silky, marzipan, orange-creamsicle, bergamot"
  # t.string "category" # Faker::Coffee.variety #=> "Pacas"
  # t.integer "user_id"
  # t.datetime "created_at", null: false
  # t.datetime "updated_at", null: false
  # t.index "\"location_id\"", name: "index_items_on_location_id"