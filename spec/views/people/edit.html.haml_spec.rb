# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'people/edit', type: :view do
  before(:each) do
    @person = assign(:person, Person.create!(
                                name: 'MyString',
                                info: 'MyText'
                              ))
  end

  it 'renders the edit person form' do
    render

    assert_select 'form[action=?][method=?]', person_path(@person), 'post' do
      assert_select 'input[name=?]', 'person[name]'

      assert_select 'textarea[name=?]', 'person[info]'
    end
  end
end
