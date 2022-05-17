require 'rails_helper'

RSpec.describe LocationItem, type: :model do
  subject(:location_item) { FactoryBot.create(:location_item) }

  describe "validations" do
    # it do 
    #   should validate_numericality_of(:quantity) 
    #     .on(:update_loc_count)
    # end 
  end

  describe "methods" do
    # describe "::update_loc_count" do
    #   it 'should accept valid to and from ids'
    # end
  end


end