# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  def time_or_nil(value)
    value&.to_time
  end

  shared_examples 'smart_date_display_case' do |label:, startdate:, enddate:, expected:|
    it label do
      expect(helper.smart_date_display(time_or_nil(startdate), time_or_nil(enddate))).to eq(expected)
    end
  end

  shared_examples 'smart_date_display_with_qualifier_case' do |label:, startdate:, enddate:, expected:, start_q: '', end_q: ''|
    it label do
      expect(
        helper.smart_date_display_with_qualifier(time_or_nil(startdate), time_or_nil(enddate), start_q, end_q)
      ).to eq(expected)
    end
  end

  describe 'admin?' do
    it 'returns true if current_user and is admin' do
      user = FactoryBot.create(:admin_user, email: 'user99@example.com')
      sign_in user
      expect(helper.admin?).to be true
    end
  end

  describe 'after_sign_in_path_for' do
    it 'returns maps_path' do
      expect(helper.after_sign_in_path_for(nil)).to eq(maps_path)
    end
  end

  describe 'basemaps' do
    it 'returns structured basemap infos' do
      expect(helper.basemaps).not_to eq(nil)
      expect(helper.basemaps['osm']['id']).to eq('osm')
    end
  end

  describe 'smart data displays' do
    [
      { label: 'returns nothing', startdate: nil, enddate: nil, expected: nil },
      {
        label: 'returns %d.%m.%Y, %H:%M (if enddate is exact the same)',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-16 15:13:04',
        expected: '16.03.2015, 15:13'
      },
      {
        label: 'returns %d.%m.%Y (if enddate is exact the same at midnight)',
        startdate: '2015-03-16 00:00:00',
        enddate: '2015-03-16 00:00:00',
        expected: '16.03.2015'
      },
      {
        label: 'returns %d.%m.%Y, %H:%M (if enddate is older)',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-16 14:13:04',
        expected: '16.03.2015, 15:13'
      },
      { label: 'returns %Y', startdate: '2015-01-01 00:00:00', enddate: nil, expected: '2015' },
      { label: 'returns %d.%m.%Y', startdate: '2015-03-16 00:00:00', enddate: nil, expected: '16.03.2015' },
      {
        label: 'returns %d.%m.%Y, %H:%M',
        startdate: '2015-03-16 20:00:00',
        enddate: nil,
        expected: '16.03.2015, 20:00'
      },
      {
        label: 'returns %d.%m.%Y, %H:%M ‒ %H:%M',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-16 20:13:04',
        expected: '16.03.2015, 15:13 ‒ 20:13'
      },
      {
        label: 'returns %d.%m.%Y, %H:%M ‒ %d.%m.%Y, %H:%M',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-17 15:13:04',
        expected: '16.03.2015, 15:13 ‒ 17.03.2015, 15:13'
      },
      {
        label: 'returns %d.%m.%Y ‒ %d.%m.%Y',
        startdate: '2015-03-16 00:00:00',
        enddate: '2015-03-17 00:00:00',
        expected: '16.03.2015 ‒ 17.03.2015'
      },
      {
        label: 'returns %Y ‒ %Y',
        startdate: '2015-01-01 00:00:00',
        enddate: '2017-01-01 00:00:00',
        expected: '2015 ‒ 2017'
      },
      {
        label: 'returns %Y (for complete year range)',
        startdate: '2015-01-01 00:00:00',
        enddate: '2015-12-31 00:00:00',
        expected: '2015'
      }
    ].each do |test_case|
      include_examples 'smart_date_display_case', **test_case
    end
  end

  describe 'smart data with qualifier displays' do
    [
      { label: 'returns nothing', startdate: nil, enddate: nil, expected: nil },
      {
        label: 'returns %d.%m.%Y, %H:%M (if enddate is exact the same)',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-16 15:13:04',
        expected: '16.3.2015, 15:13'
      },
      {
        label: 'returns %d.%m.%Y (if enddate is exact the same at midnight)',
        startdate: '2015-03-16 00:00:00',
        enddate: '2015-03-16 00:00:00',
        expected: '16.3.2015'
      },
      {
        label: 'returns %d.%m.%Y, %H:%M (if enddate is older)',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-16 14:13:04',
        expected: '16.3.2015, 15:13'
      },
      {
        label: 'returns %Y with qualifier',
        startdate: '2015-01-01 00:00:00',
        enddate: nil,
        start_q: 'circa',
        end_q: '',
        expected: 'ca. 2015'
      },
      {
        label: 'returns %Y without qualifier when start is year-only',
        startdate: '2015-01-01 00:00:00',
        enddate: nil,
        expected: '2015'
      },
      { label: 'returns %d.%m.%Y', startdate: '2015-03-16 00:00:00', enddate: nil, expected: '16.3.2015' },
      {
        label: 'returns %d.%m.%Y, %H:%M',
        startdate: '2015-03-16 20:00:00',
        enddate: nil,
        expected: '16.3.2015, 20:00'
      },
      {
        label: 'returns %d.%m.%Y, %H:%M ‒ %H:%M',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-16 20:13:04',
        expected: '16.3.2015, 15:13 ‒ 20:13'
      },
      {
        label: 'returns %d.%m.%Y, %H:%M ‒ %d.%m.%Y, %H:%M',
        startdate: '2015-03-16 15:13:04',
        enddate: '2015-03-17 15:13:04',
        expected: '16.3.2015, 15:13 ‒ 17.3.2015, 15:13'
      },
      {
        label: 'returns %d.%m.%Y ‒ %d.%m.%Y',
        startdate: '2015-03-16 00:00:00',
        enddate: '2015-03-17 00:00:00',
        expected: '16.3.2015 ‒ 17.3.2015'
      },
      {
        label: 'returns ca. %Y ‒ %Y with qualifier',
        startdate: '2015-01-01 00:00:00',
        enddate: '2017-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2015 ‒ 2017'
      },
      {
        label: 'returns ca. %d.%m ‒ %d.%m.%Y with qualifier for same year partial range',
        startdate: '2015-02-01 00:00:00',
        enddate: '2015-02-10 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 1.2 ‒ 10.2.2015'
      },
      {
        label: 'returns ca. %Y ‒ %Y with qualifier/2',
        startdate: '2015-01-01 00:00:00',
        enddate: '2016-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2015 ‒ 2016'
      },
      {
        label: 'returns ca. %Y with qualifier',
        startdate: '2015-01-01 00:00:00',
        enddate: '2015-12-31 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2015'
      },
      {
        label: 'returns ca. %Y with qualifier/2',
        startdate: '2015-01-01 00:00:00',
        enddate: '2015-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2015'
      },
      {
        label: 'returns ca. %Ys with qualifier',
        startdate: '2010-01-01 00:00:00',
        enddate: '2020-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2010s'
      },
      {
        label: 'returns ca. %Ys ‒ %Ys with qualifier',
        startdate: '2000-01-01 00:00:00',
        enddate: '2020-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2000s ‒ 2020s'
      },
      {
        label: 'returns ca. %Ys ‒ %Ys with qualifier for same decade year edge case',
        startdate: '2000-01-01 00:00:00',
        enddate: '2000-12-31 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 2000s ‒ 2000s'
      },
      {
        label: 'returns %Y ‒ %Ys with circa end qualifier and circa start qualifier',
        startdate: '1992-01-01 00:00:00',
        enddate: '2000-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'circa',
        expected: 'ca. 1992 ‒ 2000'
      },
      {
        label: 'returns %m.d.y ‒ ca. %Ys with exact startdate qualifier and circa enddate qualifier',
        startdate: '2000-08-15 00:00:00',
        enddate: '2008-01-01 00:00:00',
        start_q: 'exact',
        end_q: 'circa',
        expected: '15.8.2000 ‒ ca. 2008'
      },
      {
        label: 'returns ca. %Y ‒ %Y with circa start qualifier and non-qualified end on 01.01',
        startdate: '2010-08-15 00:00:00',
        enddate: '2024-01-01 00:00:00',
        start_q: 'circa',
        end_q: '',
        expected: 'ca. 2010 ‒ 2024'
      },
      {
        label: 'returns ca. %Y ‒ %d.%m.%Y with circa start qualifier and non-qualified end date',
        startdate: '2010-08-15 00:00:00',
        enddate: '2024-10-15 00:00:00',
        start_q: 'circa',
        end_q: '',
        expected: 'ca. 2010 ‒ 15.10.2024'
      },
      {
        label: 'returns ca. %Ys ‒ %m.d.y with circa startdate qualifier and exat enddate qualifier',
        startdate: '2000-08-15 00:00:00',
        enddate: '2008-01-01 00:00:00',
        start_q: 'circa',
        end_q: 'exact',
        expected: 'ca. 2000 ‒ 1.1.2008'
      },
      {
        label: 'returns %Y ‒ ca. %Y with only circa end qualifier',
        startdate: '1992-01-01 00:00:00',
        enddate: '2008-01-01 00:00:00',
        start_q: '',
        end_q: 'circa',
        expected: '1992 ‒ ca. 2008'
      },
      {
        label: 'returns %Y ‒ %Y without qualifiers for year-only range',
        startdate: '2015-01-01 00:00:00',
        enddate: '2017-01-01 00:00:00',
        expected: '2015 ‒ 2017'
      },
      {
        label: 'returns %Y without qualifiers for full-year range',
        startdate: '2015-01-01 00:00:00',
        enddate: '2015-12-31 00:00:00',
        expected: '2015'
      }
    ].each do |test_case|
      include_examples 'smart_date_display_with_qualifier_case', **test_case
    end
  end
end
