module PlacesHelper

  def edit_link(map_id,layer_id,id)
    " <a href=\"/maps/#{map_id}/layers/#{layer_id}/places/#{id}/edit\"><i class='fi fi-pencil'></i></a>"
    # TODO: use link_to instead:
    # html_concat link_to(edit_map_layer_place(map_id, layer_id, id), class: 'button tiny') {
    #    html_tag :i, 'aria-hidden': 'true', class: 'fa fa-pencil'
    #  }
  end
end
