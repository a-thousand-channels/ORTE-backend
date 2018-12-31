# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'start/index.html.haml', type: :view do
  it 'should render' do
    render
    expect(rendered).to match /ORTE Backend/
  end
end
