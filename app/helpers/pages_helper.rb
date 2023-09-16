# frozen_string_literal: true

module PagesHelper
  def ptype_for_select
    ptypes = %w[help faq imprint privacy]
    ptypes.each_with_object({}) { |e, m| m[e.capitalize] = e }
  end
end
