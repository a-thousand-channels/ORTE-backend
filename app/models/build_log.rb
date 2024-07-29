# frozen_string_literal: true

class BuildLog < ApplicationRecord
  belongs_to :map
  belongs_to :layer
end
