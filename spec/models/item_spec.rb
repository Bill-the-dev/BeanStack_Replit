require 'rails_helper'

RSpec.describe Item, type: :model do 
  subject(:item) { FactoryBot.create(:item) }

  describe "validations" do
    it do 
      should validate_uniqueness_of(:name)
        .scoped_to(:vendor)
        .with_message("name should be unique to vendor")
    end
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) } 
    it do 
      should validate_numericality_of(:quantity) 
        .on(:update)
    end
  end

  # describe "associations" do 
    # it { should have_many{:location_items} }
    # it { should have_many{:locations}.through(:location_items) }
  # end  
end