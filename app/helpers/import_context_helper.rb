# frozen_string_literal: true

module ImportContextHelper
  def self.write_tempfile_path(file, temp_file_path)
    Rails.cache.write("import_context/#{file.original_filename}", { file_path: temp_file_path.to_s }, expires_in: 1.week)
  end

  def self.read_tempfile_path(file_name)
    Rails.cache.read("import_context/#{file_name}")&.[](:file_path)
  end

  def self.write_not_importing_rows(file_name, rows_hash)
    prev = Rails.cache.read("import_context/#{file_name}")

    raise ImportCacheExpiredException if prev.nil?

    updated_rows = prev[:not_importing_rows] || {}

    rows_hash.each do |key, rows|
      updated_rows[key] = rows
    end

    Rails.cache.write("import_context/#{file_name}", prev.merge(not_importing_rows: updated_rows), expires_in: 1.week)
  end

  def self.read_not_importing_rows(file_name)
    prev = Rails.cache.read("import_context/#{file_name}")

    raise ImportCacheExpiredException if prev.nil?

    prev[:not_importing_rows] || {}
  end

  def self.write_importing_rows(file_name, rows)
    prev = Rails.cache.read("import_context/#{file_name}")

    raise ImportCacheExpiredException if prev.nil?

    Rails.cache.write("import_context/#{file_name}", prev.merge(importing_rows: rows), expires_in: 1.week)
  end

  def self.read_importing_rows(file_name)
    Rails.cache.read("import_context/#{file_name}")&.[](:importing_rows)
  end

  def self.write_importing_duplicate_rows(file_name, rows)
    prev = Rails.cache.read("import_context/#{file_name}")

    raise ImportCacheExpiredException if prev.nil?

    Rails.cache.write("import_context/#{file_name}", prev.merge(importing_duplicate_rows: rows), expires_in: 1.week)
  end

  def self.read_importing_duplicate_rows(file_name)
    Rails.cache.read("import_context/#{file_name}")&.[](:importing_duplicate_rows)
  end

  def self.delete_tempfile_path(file_name)
    Rails.cache.delete("import_context/#{file_name}")
  end

  def duplicate_key_values(import_mapping, place)
    key_mappings = import_mapping.mapping.select { |mapping| mapping['key'] }
    return nil if key_mappings.empty?

    key_mappings.to_h do |mapping|
      [mapping['model_property'], place[mapping['model_property']]]
    end
  end
end
