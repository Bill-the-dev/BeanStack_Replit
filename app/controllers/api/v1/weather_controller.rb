class Api::V1::WeatherController < ApplicationController
  require "rest-client"
  before_action :set_location, only: %i[ show ]

  # /api/v1/locations/:location_id/weather
  def show
    # replit req's alternate credentials
    # api_key = Rails.application.credentials.open_weather_api
    api_key = "929634c6b887f6227ff8635266438ca6"

    zip_weather_url = "https://api.openweathermap.org/data/2.5/weather?zip=#{@location.zip},#{@location.country}&units=imperial&appid=#{api_key}"

    res_weather = RestClient.get(zip_weather_url)
    @data = JSON.parse(res_weather.body, object_class: OpenStruct)

    weather = { temp: @data.main.temp.round(0), description: @data.weather[0].description }

    render json: weather
  end 

  private
    def set_location
      @location = Location.find(params[:location_id])
    end

    # Only allow a list of trusted parameters through.
    # def location_params
    #   params.require(:location).permit(:city, :state, :country, :zip, :weather, :item_id)
    # end
end

    # -- COORDINATES ALTERNATIVE --
    # Convert City, State, Country into coordinates
    # city, state, country = params[:city], params[:state], params[:country]
    # get_coord_url = "http://api.openweathermap.org/geo/1.0/direct?q=#{city},#{state},#{country}&limit=#{limit}&appid=#{api_key}"
    
    # res_coord = RestClient.get(get_coord_url)
    # coords = JSON.parse(res_coord.body)
    # lat, lon = coords["lat"], coords["lon"]

    # coord_weather_url = "https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&units=imperial&appid=#{api_key}"

    # weather_icon = "http://openweathermap.org/img/wn/#{@data.weather[0].icon}@2x.png"