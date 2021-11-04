require 'rails_helper'

RSpec.describe 'people/new', type: :view do
  before(:each) do
    assign(:person, Person.new(
                      name: 'MyString',
                      info: 'MyText'
                    ))
  end

  it 'renders new person form' do
    render

    assert_select 'form[action=?][method=?]', people_path, 'post' do
      assert_select 'input[name=?]', 'person[name]'

      assert_select 'textarea[name=?]', 'person[info]'
    end
  end
end
