class Location < ApplicationRecord
  validates :city, :country, :zip, presence: true
  validates :zip, uniqueness: {case_sensitive: false}

  has_many :location_items
  has_many :items, 
    through: :location_items, 
    dependent: :destroy

  # MOVE LOCATION_ITEM
  def self.move_loc_item(params) 
    from_loc_item = LocationItem.find(params[:from_id])
    to_loc_item = LocationItem.find(params[:to_id])
    
    if (
      to_loc_item.item_id == from_loc_item.item_id && 
      to_loc_item.location_id != from_loc_item.location_id
    )  
      from_loc_item.location_quantity -= params[:value].to_i
      if from_loc_item.save!
        to_loc_item.location_quantity += params[:value].to_i
        to_loc_item.save!
      end
    end
  end

  # MOVE LOCATION ITEMS PARAMS
  # (from_id: 1, to_id: 26, value: 3)
  # item ids must match, location ids must differ 
  # value int as number of items to move
  # subtract from origin, from_id, update
  # add to destination, to_id, update

end

# [WIP] Quantity validations:
# `Item.quantity` is assigned AFTER making locations, items, and location_items by counting each matching `LocationItem` in each `Location`.  This should only validate when it is updated, considering an `item` is created without a `quantity` initially. `validates :quantity, on: :update` had unexpected behavior during testing and was removed.