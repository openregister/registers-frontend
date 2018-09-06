# frozen_string_literal: true

require 'clockwork'
require File.expand_path('../config/boot',        __dir__)
require File.expand_path('../config/environment', __dir__)

module Clockwork
  handler do |job|
    Rails.logger.info "Executing: #{job}"
    system(job)
  end

  every(30.minute, 'Update register data') {
    `rake registers_frontend:populate_db:fetch_later`
  }

  every(30.minute, 'Update authorities') {
    `rake registers_frontend:populate_authorities:fetch_later`
  }
end
