# frozen_string_literal: true

module LayersHelper
  def tooltip_display_mode_for_select
    [['---', 'none'], ['Tooltip, permanent', 'permanent'], ['Tooltip, on Mouse-over', 'shy']]
  end

  def places_sort_order_for_select
    [['ID (default)', 'id'], %w[Startdate startdate]]
  end
end
