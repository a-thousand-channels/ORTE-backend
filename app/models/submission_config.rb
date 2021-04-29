class SubmissionConfig < ApplicationRecord
  belongs_to :layer, optional: true
end