class Api::V1::LocationItemsController < ApplicationController
  before_action :set_location, only: %i[ show update destroy ]
  
  # GET /locations/1/location_items
  def index
    @location_items = LocationItem.where(location_id: params[:location_id])
    render json: @location_items
  end

  # GET /locations/1/location_items/1
  def show
    render json: @location_item
  end
  
  # POST /locations/1/location_items
  def create
    @location_item = LocationItem.new(location_item_params)
    
    if @location_item.save 
      render json: @location_item, status: :created, location: api_v1_location_location_item_path(@location_item)
    else
      render json: @location_item.errors, status: :unprocessable_entity
    end
  end
  
  # PATCH/PUT /locations/1/location_items/1
  def update
    if @location_item.update(location_item_params)
      render json: api_v1_location_location_item_path(@location_item)
    else
      render json: @location_item.errors, status: :unprocessable_entity
    end
  end

  # DELETE only as item dependent destroy
  # # DELETE /locations/1/location_items/1

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location
      @location_item = LocationItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def location_item_params
      params.require(:location_item).permit(:location_id, :item_id, :location_quantity) 
    end
end
