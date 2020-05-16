# frozen_string_literal: true

json.array! @layers, partial: 'layers/layer', as: :layer
