Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :items
      resources :locations do
        resources :location_items
        post '/moveitem', to: 'locations#move_item', as: 'move_loc_item'
        get '/weather', to: 'weather#show', as: 'weather'
      end
    end
  end
  # Defines the root path route ("/")
  root to: "api/v1/locations#index"
end
