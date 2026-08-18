# frozen_string_literal: true

class Hyperlink < ApplicationRecord
  belongs_to :place

  validates :url, presence: true, format: { with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), message: 'should be a valid URL' }
end
