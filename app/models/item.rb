class Item < ApplicationRecord
  validates :name, :price, presence: true
  validates :name, uniqueness: { scope: :vendor, message: "name should be unique to vendor"}
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, on: :update
  # RSpec on update and quantity unpredictable behavior

  has_many :location_items
  has_many :locations,
    through: :location_items
end
