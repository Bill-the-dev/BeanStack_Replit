[![Run on Repl.it](https://repl.it/badge/github/Bill-the-dev/BeanStack)](https://replit.com/@Bill-the-dev/BeanStackReplit)



# BeanStack Inventory Tracker

Keep track of your coffee inventory!  

## Setup

*Ruby 3.0.3 & Rails 7.0.3* 

#### Install and Run
1. Run `bundle install` to install all req'd gems
2. Run `bundle exec rails db:setup` to create, migrate, and seed the db in one command
<!--     + [Alternative] `bundle exec rails db:setup` is equivalent of the following (3) commands:
      - Run `bundle exec rails db:create` to start local database 
      - Run `bundle exec rails db:migrate` to create database tables in the db
      - Run `bundle exec rails db:seed` to seet the tables with initial data -->
3. Click the green `Run` button at the top of the window
<!--     + [Alternative] Replit runs the equivalent of:  -->
<!--       - Run `bundle exec rails server -p 3001` to start server on localhost://3001 -->

#### Tests - RSpec [WIP]
4. Run `bundle exec rspec` to run all tests  
    For specific tests by section:
      - Models `bundle exec rspec spec/models`
      - Requests (controller CRUD) `bundle exec rspec spec/request`  

<!-- Excluded due to replit hosting issues -->
<!-- Front end - React and Material UI [WIP]
- (Optional) `npm run start` to start front end React.js on localhost://3000
- Currently functional for `Item` index and CRUD -->

## BeanStack API Features
- `Item` CRUD
  - Create, Read, Update, and Delete inventory items
- `Location` CRUD
  - Create warehouse locations 
  - Assign new `LocationItem` inventory to specific locations
  - Shift existing `LocationItem` quantities between warehouse locations
- `Location` Weather through external API

## Notes and Assumptions

### Location CRUD
- Assumes new location starts with all possible inventory items set to `quantity: 0` to allow for easily editable totals across locations. 

- `Zip` 
  - Canadian zip codes use only the 3-character "outwards" codes.
  - US zip codes use only the 5-digit numerical codes.

- `Country` 
  - Use 2-character country codes such as `CA` for Canada or `US` for the United States. 

### Weather API
- Opted not to use a `Weather` model for simplicities' sake.  I'm not sure if this is convention when making a simple external API call.  If more was required I would have kept the *'big model, little controller'* philosophy.
- The API updates the weather data on inital seed and when explicitly called.  Next steps are to use jobs / caching to have the weather update every X minutes.

### Move Item to/from Location
- `LocationItem` controller uses `self.update_loc_count` method to move inventory from one location to another. Thinking through this method, I assumed parameters (`value, from_id, to_id`) would likely come from a front end.
- I intend to validate item quantities to ensure parameter values and results are all poitive integers. Something along the lines of:
  `validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: :update_loc_count`

### RSpec Tests
- Initial testing includes basic model-level validations and controller CRUD req/res.  More to come! 
- Opted for `shoulda-matchers` gem for simple initial testing. Allows one-line tests with more detailed errors.
  - `it { should validate_presence_of(:name) }` is equivalent to:
    ```Ruby
    it "should validate presence of name" do 
      coffee1 = Item.new(quantity: 22, price: 12.99)
      expect(coffee1.valid?).to be false
    end
    ```

### DB Queries Quick Reference 
Run `bundle exec rails console`
- All items 
  `Item.all`
- All locations
  `Location.all`
- All location items
  `LocationItem.all`
- All items at a given location (example `id: 10`)
  `LocationItem.where(location: 10)`
- Quantity of a given item at a given location (example location `id: 1`, item `id: 3`)
  `LocationItem.where(location: 1, item: 3).select("location_quantity")` 
- Move # quantity from location 1 to location 2, note `from_id` and `to_id` are `LocationItem` ids.
  `LocationItem.update_loc_count(value, from_id, to_id)`
- Get location weather
  `Location.where(id: 1).pluck("weather")[0]` 

### BE Routes Quick Reference
Append routes to `https://beanstackreplit.bill-the-dev.repl.co` after starting server `bundle exec rails s`
For full detail run `bundle exec rails routes`  
  
#### Locations 
- params: city, state (if applicable), country (two-letter code), and zip (3-character CA *or* 5-digit US, type:string) 
- Locations Index (root)  GET`/` or `/api/v1/locations`
- Locations Create        POST `/api/v1/locations` 
- Locations Show          GET `/api/v1/locations/:id`
- Locations Update        PATCH / PUT `/api/v1/locations/:id`
- Locations Destroy       DELETE `/api/v1/locations/:id`  
  
  
#### Locations Weather
- Locations Weather       GET `api/v1/locations/:id/weather`  
  
  
#### Items 
- params: name, vendor, price (type:decimal), description (type:text), category, user_id (default id:1) 
  - note: quantity (set by total matching`LocationItem`s, only update through `LocationItem`)
- Items Index (root)  GET`/` or `/api/v1/items`
- Items Create        POST `/api/v1/items` 
- Items Show          GET `/api/v1/items/:id`
- Items Update        PATCH / PUT `/api/v1/items/:id`
- Items Destroy       DELETE `/api/v1/items/:id`

#### LocationItems
- Nested routes within location.  I thought it most useful to have a given locations items and quantities displayed as part of the location.
- params: location_id, item_id, location_quantity (all quantity updates should be done here)
- LocationItems Index   GET `/api/v1/locations/:location_id/location_items`
- LocationItems Create  POST `/api/v1/locations/:location_id/location_items`
- LocationItems Show    GET `/api/v1/locations/:location_id/location_items/:id`
- LocationItems Update  PATCH / PUT `/api/v1/locations/:location_id/location_items/:id`
- LocationItems Destroy DELETE `/api/v1/locations/:location_id/location_items/:id`

#### Move LocationItem From/To Location
- Nested routes within location. I imagined selecting a LocationItem on the front end and inputting destination location and quantity.
  - both ids belong to the same 'type' of `LocationItem` (same `Item.id`, different `location.id`). 
  - if no additional items have been added, the ids are seeded at gaps of 25.  For example, `LocationItem`(id:1) & `LocationItem`(id:26) are valid because they have the same `Item.id` and different `Location.id`.  All quantities are seeded with a minimum of 5.
- params: to_id, from_id, quantity 
- Location `/api/v1/locations/:location_id/moveitem`

## Continued Development
This was a fun project to tackle!  Going forward, my immediate priorities include strengthening validations at the model and db levels, continuing to expand RSpec testing, and learning how to incorporate Rails jobs.  On the front end I will continue to build components for all developed features.  

- Validations will be more robust at the model and db levels.
  - `Item.quantity` is assigned AFTER making locations, items, and location_items by counting each matching `LocationItem` in each `Location`.  This should only validate when it is updated, considering an `item` is created without a `quantity` initially. `validates :quantity, on: :update` 
- Inventory utilization tools
  - Inventory 'on-hand' v. 'ordered' with 'arrive by' at location
  - Rate of sales, weeks of supply, cost analysis
- User Authentication
  - User signup, login, logout 
  - Permissions for Admin v. User
  - User group inventories (per company / organization)
- Shipments and purchase order queue
- Custom table columns (sizing, color, etc.)
- AWS S3 hosting and ActiveStorage for product images

### Hosting on Replit
- GitHub/Replit integration is currently bugged, which the Replit team is aware of.  I have worked through available docs, reached out on the Replit Discord, and submitted detailed bug reports. Not an issue, but noted here because it necessitated a few changes.     
  - Used Rails app generated by Replit, which contains more 'weight' than strictly necessary.  Ideally, app would be created using `rails new <project_name> --api`, which excludes any middleware / Action Controller modules primarily useful for browser applications and skips the 'front end' of `rails g` resource generators. 
  - Future updates may require forking the repo and rehosting on Replit.
  - Credentials should be managed by Rails directly, Replit 'secrets' caused inconsistent behavior with API.
  - SQLite3 is only supported by Replit in `development` and not `production`.  Future updates may require remote PostgreSQL db or similar. 
  - Front end completed for Items index and all CRUD functions using React and Material UI.  Not included for this submission

For a peek at the front end and more lightweight backend, check out my main repo here!
[BeanStack FS](https://github.com/Bill-the-dev/BeanStack)




<!-- # Rails on Replit

This is a template to get you started with Rails on Replit. It's ready to go so you can just hit run and start coding!

This template was generated using `rails new` (after you install the `rails` gem from the packager sidebar) so you can always do that if you prefer to set it up from scratch. The only had two make config changes we had to make to run it on Replit:

- bind the app on `0.0.0.0` instead of `localhost` (see `.replit`)
- allow `*.repl.co` hosts (see `config/environments/development.rb`)
- allow the app to be iframed on `replit.com` (see `config/application.rb`)

## Running the app

Simple hit run! You can edit the run command from the `.replit` file.

## Running commands

Start every command with `bundle exec` so that it runs in the context of the installed gems environment. The console pane will give you output from the server but you can run arbitrary command from the shell without stopping the server.

## Database

SQLite would work in development but we don't recommend running it in production. Instead look into using the built-in [Replit database](http://docs.replit.com/misc/database). Otherwise you are welcome to connect databases from your favorite provider. 

## Help

If you need help you might be able to find an answer on our [docs](https://docs.replit.com) page. Feel free to report bugs and give us feedback [here](https://replit.com/support). -->
