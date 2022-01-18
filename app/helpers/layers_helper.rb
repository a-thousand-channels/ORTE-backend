# frozen_string_literal: true

module LayersHelper
  def tooltip_display_mode_for_select
    tooltip_display_modes = %w[none permanent shy]
    tooltip_display_modes.each_with_object({}) { |e, m| m[e.capitalize] = e; }
  end

  def places_sort_order_for_select
    places_sort_order_options = %w[id startdate]
    places_sort_order_options.each_with_object({}) { |e, m| m[e.capitalize] = e; }
  end
end
