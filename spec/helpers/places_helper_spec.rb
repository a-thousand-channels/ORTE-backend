require 'rails_helper'


RSpec.describe PlacesHelper, type: :helper do

  describe "edit_link" do
    it 'it returns a visual edit link' do
      expect(helper.edit_link(1,2,3)).to eq(" <a href=\"/maps/1/layers/2/places/3/edit\" class='edit_link'><i class='fi fi-pencil'></i></a>")
    end
  end

end
