# frozen_string_literal: true

module QueryCounter
  def count_queries(&block)
    query_count = 0
    ActiveSupport::Notifications.subscribed(
      lambda { |_name, _start, _finish, _id, payload|
        query_count += 1 unless payload[:name].in?(%w[SCHEMA TRANSACTION])
      },
      'sql.active_record',
      &block
    )
    query_count
  end
end
