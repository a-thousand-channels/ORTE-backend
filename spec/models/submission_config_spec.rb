require 'rails_helper'

RSpec.describe SubmissionConfig, type: :model do
  it 'has a valid factory' do
    expect(build(:submission_config)).to be_valid
  end

end
