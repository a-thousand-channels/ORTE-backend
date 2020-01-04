module PlacesHelper

  def show_link(title, map_id, layer_id, id)
    #html_concat link_to(map_layer_place_path(map_id, layer_id, id)) {
    #  html_concat(title)
    #}
    " <a href=\"/maps/#{map_id}/layers/#{layer_id}/places/#{id}\">
      #{title}
      </a>"
  end

  def edit_link(map_id, layer_id, id)
    #html_concat link_to(edit_map_layer_place_url(map_id, layer_id, id)) {
    #  html_tag :i, 'aria-hidden': 'true', class: 'fa fa-pencil'
    #}
    " <a href=\"/maps/#{map_id}/layers/#{layer_id}/places/#{id}/edit\"><i class='fi fi-pencil'></i></a>"
  end
end
