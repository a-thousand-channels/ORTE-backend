# frozen_string_literal: true

module ImportContextHelper
  def self.write_tempfile_path(file, temp_file_path)
    Rails.cache.write("import_context/#{file.original_filename}", { file_path: temp_file_path.to_s }, expires_in: 1.week)
  end

  def self.read_tempfile_path(file_name)
    Rails.cache.read("import_context/#{file_name}")[:file_path]
  end
end
