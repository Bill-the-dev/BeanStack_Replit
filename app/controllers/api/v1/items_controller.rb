class Api::V1::ItemsController < ApplicationController
  before_action :set_item, only: %i[ show update destroy ]

  # GET /items
  def index
    @items = Item.all

    render json: @items
  end

  # GET /items/1
  def show
    if @item
      render json: @item
    else 
      render json: 'item does not exist', status: 404
    end
  end

  # POST /items
  def create
    @item = Item.new(item_params)

    if @item.save
      render json: @item, status: :created, location: api_v1_items_path(@item)
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /items/1
  def update
    if @item.update(item_params)
      # render json: @item # original
      render json: @item, location: api_v1_items_path(@item)
    else
      render json: @item.errors, status: :unprocessable_entity
    end
  end

  # DELETE /items/1
  def destroy
    @item.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      # begin / rescue prevents ActiveRecord exception from halting (RSpec)
      begin
        @item = Item.find(params[:id])
      rescue => exception
        @item = nil
      end
    end

    # Only allow a list of trusted parameters through.
    def item_params
      params.require(:item).permit(:name, :vendor, :quantity, :price, :description, :category, :user_id, :location_id)
    end
end
