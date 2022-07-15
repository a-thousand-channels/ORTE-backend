# frozen_string_literal: true

class ApplicationCable::Connection < ActionCable::Connection::Base
    identified_by :current_user
    # rescue_from StandardError, with: :report_error

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if (verified_user = env['warden'].user)
        verified_user
      else
        reject_unauthorized_connection
      end
    end

    def report_error(error)
      puts 'ActionCable ERROR'
      puts error.inspect
      # TODO: SERVICE.notify(e)
    end
end
