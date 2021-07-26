require 'rails_helper'

RSpec.describe "submission_configs/show", type: :view do
  before(:each) do
    @submission_config = assign(:submission_config, SubmissionConfig.create!(
      title_intro: "Title Intro",
      subtitle_intro: "Subtitle Intro",
      intro: "MyText",
      title_outro: "Title Outro",
      outro: "MyText",
      use_city_only: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title Intro/)
    expect(rendered).to match(/Subtitle Intro/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Title Outro/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/false/)
  end
end
