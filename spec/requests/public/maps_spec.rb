# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Public Maps JSON API', type: :request do
  before do
    @map = FactoryBot.create(:map, published: true)
    @layer = FactoryBot.create(:layer, map: @map, published: true)
    @place = FactoryBot.create(:place, layer: @layer, published: true)
  end

  describe 'GET /public/maps/:id.json' do
    context 'with map-level pages' do
      it 'includes published pages in response' do
        page = FactoryBot.create(:page, :with_map, pageable: @map, published: true)
        get "/public/maps/#{@map.id}.json"

        expect(response).to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response['map']['pages']).to be_an(Array)
        expect(json_response['map']['pages']).to include(hash_including('id' => page.id))
      end

      it 'excludes unpublished map pages from response' do
        unpub_page = FactoryBot.create(:page, :with_map, pageable: @map, published: false)
        pub_page = FactoryBot.create(:page, :with_map, pageable: @map, published: true)

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        page_ids = json_response['map']['pages'].map { |p| p['id'] }
        expect(page_ids).to include(pub_page.id)
        expect(page_ids).not_to include(unpub_page.id)
      end

      it 'includes correct page attributes in map pages' do
        page = FactoryBot.create(:page, :with_map, pageable: @map, published: true,
                                                   title: 'Map Page Title', subtitle: 'Subtitle',
                                                   teaser: 'Teaser text', footer: 'Footer text')

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        map_page = json_response['map']['pages'].find { |p| p['id'] == page.id }
        expect(map_page).to include(
          'id' => page.id,
          'title' => 'Map Page Title',
          'subtitle' => 'Subtitle',
          'teaser' => 'Teaser text',
          'footer' => 'Footer text',
          'published' => true
        )
        expect(map_page).to have_key('created_at')
        expect(map_page).to have_key('updated_at')
      end

      it 'returns empty pages array when no pages exist' do
        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        expect(json_response['map']['pages']).to eq([])
      end
    end

    context 'with place-level pages' do
      it 'includes published place pages nested under places' do
        page = FactoryBot.create(:page, :with_place, pageable: @place, published: true)

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        place_pages = json_response['map']['layer'][0]['places'][0]['pages']
        expect(place_pages).to be_an(Array)
        expect(place_pages).to include(hash_including('id' => page.id))
      end

      it 'excludes unpublished place pages from response' do
        unpub_page = FactoryBot.create(:page, :with_place, pageable: @place, published: false)
        pub_page = FactoryBot.create(:page, :with_place, pageable: @place, published: true)

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        place_pages = json_response['map']['layer'][0]['places'][0]['pages']
        page_ids = place_pages.map { |p| p['id'] }
        expect(page_ids).to include(pub_page.id)
        expect(page_ids).not_to include(unpub_page.id)
      end

      it 'includes correct page attributes in place pages' do
        page = FactoryBot.create(:page, :with_place, pageable: @place, published: true,
                                                     title: 'Place Page Title', subtitle: 'Place Subtitle',
                                                     teaser: 'Place teaser', footer: 'Place footer')

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        place_page = json_response['map']['layer'][0]['places'][0]['pages'].find { |p| p['id'] == page.id }
        expect(place_page).to include(
          'id' => page.id,
          'title' => 'Place Page Title',
          'subtitle' => 'Place Subtitle',
          'teaser' => 'Place teaser',
          'footer' => 'Place footer',
          'published' => true
        )
        expect(place_page).to have_key('created_at')
        expect(place_page).to have_key('updated_at')
      end

      it 'each place has its own independent pages array' do
        place2 = FactoryBot.create(:place, layer: @layer, published: true)

        page1 = FactoryBot.create(:page, :with_place, pageable: @place, published: true, title: 'Page 1')
        page2 = FactoryBot.create(:page, :with_place, pageable: @place, published: true, title: 'Page 2')
        page3 = FactoryBot.create(:page, :with_place, pageable: place2, published: true, title: 'Page 3')

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        places = json_response['map']['layer'][0]['places']

        place1_pages = places.find { |p| p['id'] == @place.id }['pages']
        place2_pages = places.find { |p| p['id'] == place2.id }['pages']

        place1_page_titles = place1_pages.map { |p| p['title'] }
        place2_page_titles = place2_pages.map { |p| p['title'] }

        expect(place1_page_titles).to include('Page 1', 'Page 2')
        expect(place1_page_titles).not_to include('Page 3')
        expect(place2_page_titles).to include('Page 3')
        expect(place2_page_titles).not_to include('Page 1', 'Page 2')
      end

      it 'returns empty pages array for places without pages' do
        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        place_pages = json_response['map']['layer'][0]['places'][0]['pages']
        expect(place_pages).to eq([])
      end
    end

    context 'edge cases' do
      it 'includes map pages even with no places' do
        map_only = FactoryBot.create(:map, published: true)
        page = FactoryBot.create(:page, :with_map, pageable: map_only, published: true)

        get "/public/maps/#{map_only.id}.json"

        json_response = JSON.parse(response.body)
        expect(json_response['map']['pages']).to include(hash_including('id' => page.id))
      end

      it 'does not include pages for unpublished places' do
        unpub_place = FactoryBot.create(:place, layer: @layer, published: false)
        page = FactoryBot.create(:page, :with_place, pageable: unpub_place, published: true)

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        places = json_response['map']['layer'][0]['places']
        place_ids = places.map { |p| p['id'] }
        expect(place_ids).not_to include(unpub_place.id)
      end

      it 'does not include pages for places in unpublished layers' do
        unpub_layer = FactoryBot.create(:layer, map: @map, published: false)
        place_in_unpub_layer = FactoryBot.create(:place, layer: unpub_layer, published: true)
        page = FactoryBot.create(:page, :with_place, pageable: place_in_unpub_layer, published: true)

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        layers = json_response['map']['layer']
        layer_ids = layers.map { |l| l['id'] }
        expect(layer_ids).not_to include(unpub_layer.id)
      end

      it 'returns both map and place pages in single response' do
        map_page = FactoryBot.create(:page, :with_map, pageable: @map, published: true, title: 'Map Page')
        place_page = FactoryBot.create(:page, :with_place, pageable: @place, published: true, title: 'Place Page')

        get "/public/maps/#{@map.id}.json"

        json_response = JSON.parse(response.body)
        map_pages = json_response['map']['pages']
        place_pages = json_response['map']['layer'][0]['places'][0]['pages']

        expect(map_pages.map { |p| p['title'] }).to include('Map Page')
        expect(place_pages.map { |p| p['title'] }).to include('Place Page')
      end
    end
  end
end
