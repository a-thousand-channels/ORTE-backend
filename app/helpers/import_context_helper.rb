# frozen_string_literal: true

module ImportContextHelper
  def self.write_tempfile_path(file, temp_file_path)
    Rails.cache.write("import_context/#{file.original_filename}", { file_path: temp_file_path.to_s }, expires_in: 1.week)
  end

  def self.read_tempfile_path(file_name)
    Rails.cache.read("import_context/#{file_name}")[:file_path]
  end

  def self.write_importing_rows(file_name, rows)
    Rails.cache.write("import_context/#{file_name}/importing_rows", { rows: rows }, expires_in: 1.week)
  end

  def self.read_importing_rows(file_name)
    Rails.cache.read("import_context/#{file_name}/importing_rows")[:rows]
  end

  def self.write_importing_duplicate_rows(file_name, rows)
    Rails.cache.write("import_context/#{file_name}/importing_duplicate_rows", { rows: rows }, expires_in: 1.week)
  end

  def self.read_importing_duplicate_rows(file_name)
    Rails.cache.read("import_context/#{file_name}/importing_duplicate_rows")[:rows]
  end

  def self.delete_tempfile_path(file_name)
    Rails.cache.delete("import_context/#{file_name}")
  end
end
