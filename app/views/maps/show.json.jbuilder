if @map.published
  json.partial! "maps/map", map: @map
end
