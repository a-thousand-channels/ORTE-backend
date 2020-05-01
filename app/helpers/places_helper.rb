module PlacesHelper

  include Rails.application.routes.url_helpers

   def default_url_options
      { host: Settings.app_host}
    end  

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
    " <a href=\"/maps/#{map_id}/layers/#{layer_id}/places/#{id}/edit\" class='edit_link'><i class='fi fi-pencil'></i></a>"
  end

  def add_new_entry_link(place)
      "/maps/#{place.layer.map.id}/layers/#{place.layer.id}/places/new?location=#{@place.location}&address=#{@place.address}&zip=#{@place.zip}&city=#{@place.city}&lat=#{@place.lat}&lon=#{@place.lon}";
  end

  def image_link(image)
    if image.file.attached? 
      # url_for(image.file)
      # rails_blob_path(image.file, disposition: "attachment")
      polymorphic_url(image.file)
    end
  end

end
