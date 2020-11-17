# frozen_string_literal: true

# Configure sensitive parameters which will be filtered from the log file.
Rails.application.config.filter_parameters += %i[
  authenticity_token
  confirmation_code
  groups
  password
  username
  vrn
]
