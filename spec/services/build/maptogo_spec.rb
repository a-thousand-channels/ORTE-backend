# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Build::Maptogo do
  describe '#run' do
    before do
      @build_config = Rails.application.config_for('build/maptogo').with_indifferent_access['commands']
      @version = Rails.application.config_for('build/maptogo').with_indifferent_access['version']
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:admin_user, email: 'user99@example.com')
      @map = FactoryBot.create(:map, group_id: @group.id)
      @layer = FactoryBot.create(:layer, map_id: @map.id, published: true)
    end

    it 'returns created_at' do
      freeze_time do
        result = Build::Maptogo.new(@user, @map, @layer).build

        expect(result[:meta][:created_at]).to eq DateTime.current.to_s
        expect(result[:meta][:version]).to eq @version.to_s
      end
    end
  end
end
