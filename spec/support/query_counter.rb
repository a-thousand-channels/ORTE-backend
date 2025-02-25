module QueryCounter
  def count_queries(&block)
    query_count = 0
    ActiveSupport::Notifications.subscribed(
      ->(_name, _start, _finish, _id, payload) {
        query_count += 1 unless payload[:name].in?(['SCHEMA', 'TRANSACTION'])
      },
      'sql.active_record',
      &block
    )
    query_count
  end
end
