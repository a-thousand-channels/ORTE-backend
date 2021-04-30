# frozen_string_literal: true

json.array! @submission_configs, partial: 'submission_configs/submission_config', as: :submission_config
