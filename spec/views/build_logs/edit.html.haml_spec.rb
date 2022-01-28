# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'build_logs/edit', type: :view do
  before(:each) do
    @group = Group.create!(title: 'Group1')
    @map = Map.create!(group: @group, title: 'Test')
    @layer = Layer.create!(map: @map, title: 'TestLayer')

    @build_log = assign(:build_log, BuildLog.create!(
                                      map: @map,
                                      layer: @layer,
                                      output: 'MyString',
                                      size: 1,
                                      version: 'MyString'
                                    ))
  end

  it 'renders the edit build_log form' do
    render

    assert_select 'form[action=?][method=?]', build_log_path(@build_log), 'post' do
      assert_select 'select[name=?]', 'build_log[map_id]'

      assert_select 'select[name=?]', 'build_log[layer_id]'

      assert_select 'input[name=?]', 'build_log[output]'

      assert_select 'input[name=?]', 'build_log[size]'

      assert_select 'input[name=?]', 'build_log[version]'
    end
  end
end
