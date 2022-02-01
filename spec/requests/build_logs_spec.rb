# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'BuildLogs', type: :request do
  describe 'GET /build_logs' do
    it 'gets redirected to login' do
      get build_log_path(1)
      expect(response).to have_http_status(302)
    end
  end
end
