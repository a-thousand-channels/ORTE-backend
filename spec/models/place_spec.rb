require 'rails_helper'

RSpec.describe Place, type: :model do
  it "has a valid factory" do
    expect(build(:place)).to be_valid
  end

  describe 'Attachment' do
    it 'is valid  ' do
      subject.images.attach(io: File.open(Rails.root.join('public', 'apple-touch-icon.png')), filename: 'attachment.png', content_type: 'image/png')
      expect(subject.images).to be_attached
    end
  end

  describe 'Dates' do
    it 'returns date' do
      p = FactoryBot.create(:place, startdate: '2018-01-01', enddate: '2018-01-02')
      expect(p.date).to eq('01.01.18 ‒ 02.01.18')
    end

    it 'returns full startdate' do
      p = FactoryBot.create(:place, startdate_date: '2018-01-01', startdate_time: '20:30', enddate: '')
      expect(p.date).to eq('01.01.18, 20:30')
    end

    it 'returns full startdate without time' do
      p = FactoryBot.create(:place, startdate_date: '2018-01-01', startdate_time: '', enddate: '')
      expect(p.date).to eq('2018')
    end

    it 'returns full date range with time' do
      p = FactoryBot.create(:place, startdate_date: '2018-01-01', startdate_time: '12:00', enddate_date: '2018-01-01', enddate_time: '18:00')
      expect(p.date).to eq('01.01.18, 12:00 ‒ 18:00')
    end

    it 'returns full date range without time' do
      p = FactoryBot.create(:place, startdate_date: '2018-01-01', startdate_time: '', enddate_date: '2018-10-15')
      expect(p.date).to eq('01.01.18 ‒ 15.10.18')
    end

    it 'returns year range' do
      p = FactoryBot.create(:place, startdate_date: '2015-01-01', startdate_time: '', enddate_date: '2018-01-01')
      expect(p.date).to eq('2015 ‒ 2018')
    end
  end

  it 'edit_link' do
    m = FactoryBot.create(:map)
    l = FactoryBot.create(:layer, :map => m)
    p = FactoryBot.create(:place, :layer => l)
    expect(p.edit_link).to eq(" <a href=\"/maps/#{m.id}/layers/#{l.id}/places/#{p.id}/edit\"><i class='fi fi-pencil'></i></a>")
  end

  describe 'Address' do

    it 'full_address w/location but no address' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, :map => m)
      p = FactoryBot.create(:place, :layer => l, :address => '', :location => "A location")
      expect(p.full_address).to eq("A location")
    end

    it 'full_address w/address but no location(name)' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, :map => m)
      p = FactoryBot.create(:place, :layer => l, :address => 'An address', :location => "")
      expect(p.full_address).to eq("An address")
    end

    it 'full_address_with_city' do
      m = FactoryBot.create(:map)
      l = FactoryBot.create(:layer, :map => m)
      p = FactoryBot.create(:place, :layer => l, :address => 'An address', :location => "A location", :zip => '12345', :city => 'City')
      expect(p.full_address_with_city).to eq("A location An address, 12345 City")
    end
  end
end
