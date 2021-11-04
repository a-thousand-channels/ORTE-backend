# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/index', type: :view do
  before(:each) do
    assign(:people, [
             Person.create!(
               name: 'Name1',
               info: 'MyText1'
             ),
             Person.create!(
               name: 'Name2',
               info: 'MyText2'
             )
           ])
  end

  it 'renders a list of people' do
    render
    expect(rendered).to match(/Name1/)
    expect(rendered).to match(/Name2/)
    expect(rendered).to match(/MyText1/)
  end
end
