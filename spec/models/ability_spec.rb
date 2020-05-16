# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    describe 'abilities' do
      subject(:ability) { Ability.new(user) }
      let(:user) { nil }

      context '... when guest' do
        it { is_expected.not_to be_able_to(:manage, User.new) }
      end

      context '... when normal user' do
        User.destroy_all
        let(:user) { FactoryBot.create(:user) }

        it { is_expected.not_to be_able_to(:manage, User.new) }
      end

      context '... when admin' do
        User.destroy_all
        let(:user) { FactoryBot.create(:admin_user) }
        it { should be_able_to(:manage, User.new) }
      end
    end
  end
end
