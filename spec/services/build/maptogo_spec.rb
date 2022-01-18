# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Build::Maptogo do
  describe '#run' do
    before do
      @build_config = Rails.application.config_for('build/maptogo')
    end

    it 'returns created_at' do
      freeze_time do
        
        result = Build::Maptogo.new().build

        expect(result[:meta][:created_at]).to eq DateTime.current.to_s
      end
    end
    it 'returns version' do
        
      result = Build::Maptogo.new().build

      expect(result[:meta][:version]).to eq @build_config['version'].to_s

    end

  end
end
