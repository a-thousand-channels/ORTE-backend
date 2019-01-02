require 'rails_helper'


RSpec.describe ApplicationHelper, type: :helper do

  describe "admin?" do
    it "returns true if current_user and is admin" do
      user = FactoryBot.create(:admin_user, :email => "user99@example.com")
      sign_in user
      expect(helper.admin?).to be true
    end
  end


  describe "smart data displays" do
    it "returns %d.%m.%Y, %H:%M" do
      startdate = "2015-03-16 15:13:04".to_time
      enddate = "2015-03-16 15:13:04".to_time
      expect(helper.smart_date_display(startdate,enddate)).to eq("16.03.15, 15:13")
    end
    it "returns %d.%m.%Y, %H:%M" do
      startdate = "2015-03-16 15:13:04".to_time
      enddate = "2015-03-16 14:13:04".to_time
      expect(helper.smart_date_display(startdate,enddate)).to eq("16.03.15, 15:13")
    end
    it "returns %d.%m.%Y, %H:%M" do
      startdate = "2015-03-16 15:13:04".to_time
      enddate = "2015-03-16 20:13:04".to_time
      expect(helper.smart_date_display(startdate,enddate)).to eq("16.03.15, 15:13 ‒ 20:13")
    end
    it "returns %d.%m.%Y, %H:%M" do
      startdate = "2015-03-16 15:13:04".to_time
      enddate = "2015-03-17 15:13:04".to_time
      expect(helper.smart_date_display(startdate,enddate)).to eq("16.03.15, 15:13 ‒ 17.03.15, 15:13")
    end

  end



end
