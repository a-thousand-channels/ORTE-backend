# frozen_string_literal: true

json.array! @relations, partial: 'relations/relation', as: :relation
