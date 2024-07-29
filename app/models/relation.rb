# frozen_string_literal: true

class Relation < ApplicationRecord
  belongs_to :relation_to, class_name: 'Place'
  belongs_to :relation_from, class_name: 'Place'
end
