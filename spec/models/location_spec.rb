require 'rails_helper'

RSpec.describe Location, type: :model do
  
  subject(:location) { FactoryBot.create(:location) }

  describe "validations" do
    it { should validate_uniqueness_of(:zip).case_insensitive }
    it { should validate_presence_of(:city) }
    it { should validate_presence_of(:country) } 
    it { should validate_presence_of(:zip) } 
  end

  # describe "associations" do 
  #   it { should have_many{:location_items} }
  #   it { should have_many{:items}.through(:location_items) }
  # end

end