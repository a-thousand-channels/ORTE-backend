class MigrateVideosToPolymorphic < ActiveRecord::Migration[7.2]
  def up
    Video.where.not(place_id: nil).find_each do |video|
      video.update!(
        videoable_type: 'Place',
        videoable_id: video.place_id
      )
    end
  end

  def down
    Video.where(videoable_type: 'Place').find_each do |video|
      video.update!(
        place_id: video.videoable_id
      )
    end
  end
end
