# frozen_string_literal: true

module SubmissionsHelper
  def preview_class(local_index, form_index)
    return '' if form_index == -1

    if local_index == form_index
      ' active'
    elsif local_index < form_index
      ' done'
    else
      ' todo'
    end
  end
end
