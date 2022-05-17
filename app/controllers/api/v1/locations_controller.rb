class Api::V1::LocationsController < ApplicationController
  before_action :set_location, only: %i[ show update destroy move_item]

  # GET /locations
  def index
    @locations = Location.all

    render json: @locations
  end

  # GET /locations/1
  def show
    if @location
      render json: @location
    else 
      render json: 'location does not exist', status: 404
    end
  end

  # POST /locations
  def create
    @location = Location.new(location_params)

    if @location.save
      item_ids = Item.all.map { |item| item.id }
      item_ids.each do |item_id|
        LocationItem.create(
          location: Location.find(@location.id),
          item: Item.find(item_id),
          location_quantity: 0
        )
      end  
      render json: @location, status: :created, location: api_v1_locations_path(@location)
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /locations/1
  def update
    if @location.update(location_params)
      render json: @location, location: api_v1_locations_path(@location)
    else
      render json: @location.errors, status: :unprocessable_entity
    end
  end

  # DELETE /locations/1
  def destroy
    @location.destroy
  end

  # MOVE LOCATION_ITEM
  def move_item 
    if Location.move_loc_item(params)
      render json: "Successfully moved #{params[:value]} items from #{params[:from_id]} to #{params[:to_id]}", status: :ok 
    else 
      render json: 'Item movement not possible', status: :unprocessable_entity
    end
  end

  # item ids must match, location ids must differ
  # value int as number of items to move
  # subtract from origin, from_id, update
  # add to destination, to_id, update

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      # begin / rescue prevents ActiveRecord exception from halting (RSpec)
      begin
        @location = Location.find(params[:id])
      rescue => exception
        @location = nil
      end
    end

    # Only allow a list of trusted parameters through.
    def location_params
      params.require(:location).permit(:city, :state, :country, :zip, :weather, :item_id)
    end
end
