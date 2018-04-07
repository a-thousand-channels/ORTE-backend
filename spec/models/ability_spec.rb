# frozen_string_literal: true

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    describe 'abilities' do
      subject(:ability) { Ability.new(user) }
      let(:user) { nil }

      context '... when guest' do
        # TODO: definie abilities for guests
        # it{ should be_able_to(:read, User.new) }
        # it{ should_not be_able_to(:create, Post.new) }
      end

      context '... when normal user' do
        User.destroy_all
        let(:user) { FactoryBot.create(:user) }

        it { is_expected.not_to be_able_to(:manage, User.new) }
        # it{ should be_able_to(:manage, Post.new) }
      end

      context '... when admin' do
        User.destroy_all
        let(:user) { FactoryBot.create(:admin_user) }
        it { is_expected.not_to be_able_to(:manage, User.new) }
        # it{ should be_able_to(:manage, Post.new) }
      end
    end
  end
end
