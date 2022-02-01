# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'build_logs/show', type: :view do
  before(:each) do
    @group = Group.create!(title: 'Group1')
    @map = Map.create!(group: @group, title: 'Test')
    @layer = Layer.create!(map: @map, title: 'TestLayer')

    @build_log = assign(:build_log, BuildLog.create!(
                                      map: @map,
                                      layer: @layer,
                                      output: 'Output',
                                      size: 2,
                                      version: 'Version'
                                    ))
  end

  it 'renders attributes in <p>' do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Output/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Version/)
  end
end
