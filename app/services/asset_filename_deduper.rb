# frozen_string_literal: true

# Makes filenames unique within a single export run, so that assets copied
# into a shared flat folder (e.g. for a ZIP export) don't overwrite each other
# when two source files happen to share the same original filename.
#
# One instance per export run: "photo.jpg", "photo.jpg", "photo.jpg"
# becomes "photo.jpg", "photo-1.jpg", "photo-2.jpg" in call order.
class AssetFilenameDeduper
  def initialize
    @counts = Hash.new(0)
  end

  def unique_name_for(filename)
    filename = filename.to_s
    n = @counts[filename]
    @counts[filename] += 1
    return filename if n.zero?

    ext = File.extname(filename)
    "#{File.basename(filename, ext)}-#{n}#{ext}"
  end
end
