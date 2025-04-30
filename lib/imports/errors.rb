# frozen_string_literal: true

module Imports
  module Errors
    class MissingFieldsError < StandardError
      attr_reader :missing_fields

      def initialize(missing_fields)
        @missing_fields = missing_fields
        super("Missing required fields: #{missing_fields.join(', ')}")
      end
    end
  end
end
