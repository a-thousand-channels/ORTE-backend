if @layer.published
  json.partial! "layers/layer", layer: @layer
end
