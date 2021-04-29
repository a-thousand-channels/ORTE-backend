require 'rails_helper'

RSpec.describe "submission_configs/index", type: :view do
  before(:each) do
    assign(:submission_configs, [
      SubmissionConfig.create!(
        title_intro: "Title Intro",
        subtitle_intro: "Subtitle Intro",
        intro: "MyText",
        title_outro: "Title Outro",
        outro: "MyText",
        use_city_only: false
      ),
      SubmissionConfig.create!(
        title_intro: "Title Intro",
        subtitle_intro: "Subtitle Intro",
        intro: "MyText",
        title_outro: "Title Outro",
        outro: "MyText",
        use_city_only: false
      )
    ])
  end

  it "renders a list of submission_configs" do
    render
    assert_select "tr>td", text: "Title Intro".to_s, count: 2
    assert_select "tr>td", text: "Subtitle Intro".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: "Title Outro".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
