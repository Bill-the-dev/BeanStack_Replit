class LocationItem < ApplicationRecord
  # validates :location_quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, if: :update_loc_count

  belongs_to :location
  belongs_to :item


end
