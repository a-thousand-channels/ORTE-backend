# frozen_string_literal: true

module LayersHelper
  def tooltip_display_mode_for_select
    [['---', 'none'], ['Tooltip, permanent', 'permanent'], ['Tooltip, on Mouse-over', 'shy']]
  end

  def places_sort_order_for_select
    [['ID (default)', 'id'], %w[Startdate startdate], %w[Title title]]
  end

  def relations_coloring_for_select
    [['Random colored (default)', 'colored'], %w[Black black], %w[Monochrome monochrome]]
  end
end
