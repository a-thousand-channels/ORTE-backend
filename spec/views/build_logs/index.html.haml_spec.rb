# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'build_logs/index', type: :view do
  before(:each) do
    @group = Group.create!(title: 'Group1')
    @map = Map.create!(group: @group, title: 'Test')
    @layer = Layer.create!(map: @map, title: 'TestLayer')
    assign(:build_logs, [
             BuildLog.create!(
               map: @map,
               layer: @layer,
               output: 'Output',
               size: 2,
               version: 'Version'
             ),
             BuildLog.create!(
               map: @map,
               layer: @layer,
               output: 'Output',
               size: 2,
               version: 'Version'
             )
           ])
  end

  it 'renders a list of build_logs' do
    render
    assert_select 'tr>td', text: 'Test'.to_s, count: 2
    assert_select 'tr>td', text: 'TestLayer'.to_s, count: 2
    assert_select 'tr>td', text: 'Output'.to_s, count: 2
    assert_select 'tr>td', text: 2.to_s, count: 2
    assert_select 'tr>td', text: 'Version'.to_s, count: 2
  end
end
