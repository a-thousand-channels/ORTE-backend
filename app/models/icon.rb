# frozen_string_literal: true

class Icon < ApplicationRecord
  belongs_to :iconset
  has_one_attached :file
end
