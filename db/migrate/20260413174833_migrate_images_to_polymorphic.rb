class MigrateImagesToPolymorphic < ActiveRecord::Migration[7.2]
  def up
    Image.where.not(place_id: nil).find_each do |image|
      image.update!(
        # avoid strip_exif_data is getting called:
        skip_beforesave_callback: true,
        imageable_type: 'Place',
        imageable_id: image.place_id
      )
    end
  end

  def down
    Image.where(imageable_type: 'Place').find_each do |image|
      image.update!(
        place_id: image.imageable_id
      )
    end
  end
end
