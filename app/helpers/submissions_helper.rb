# frozen_string_literal: true

module SubmissionsHelper
  def preview_class(local_index, form_index)
    return '' if form_index == -1
    if local_index == form_index
      return ' active'
    elsif local_index < form_index
      return  ' done'
    else
      return  ' todo'
    end
  end
end
