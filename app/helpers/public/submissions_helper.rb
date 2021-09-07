# frozen_string_literal: true

module Public::SubmissionsHelper
  def current_page_params
    # Modify this list to whitelist url params for linking to the current page
    request.params.slice('query', 'filter', 'sort')
  end
end
