# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'public/submissions/edit', type: :view do
  before(:each) do
    @map = FactoryBot.create(:map)
    @layer = FactoryBot.create(:layer, map_id: @map.id, public_submission: true)
    @submission = FactoryBot.create(:submission)
    @locale = 'en'
    @form_url = submissions_path(@submission, locale: @locale, layer_id: @layer.id)
    assign(:map, @map)
    assign(:layer, @layer)
    assign(:form_url, @form_url)
    assign(:submission, @submission)
    assign(:submission_config, SubmissionConfig.new(
                                 title_intro: 'MyString',
                                 subtitle_intro: 'MyString',
                                 intro: 'MyText',
                                 title_outro: 'MyString',
                                 outro: 'MyText',
                                 use_city_only: false,
                                 layer_id: @layer.id
                               ))
  end

  it 'renders edit submission form' do
    render

    assert_select 'h1', 'MyString'
    assert_select 'form[action=?][method=?]', submissions_path(@submission, locale: @locale, layer_id: @layer.id), 'post' do
      assert_select 'input[name=?]', 'submission[name]'
      assert_select 'input[name=?]', 'submission[email]'
      assert_select 'input[name=?]', 'submission[rights]'
      assert_select 'input[name=?]', 'submission[privacy]'
    end
  end
end
