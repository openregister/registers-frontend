# frozen_string_literal: true

require 'clockwork'
require File.expand_path('../../config/boot',        __FILE__)
require File.expand_path('../../config/environment', __FILE__)

include Clockwork

handler do |job|
  puts "Running #{job}"
  system(job)
end

every(1.minute, 'Update database') {
  `rake registers_frontend:populate_db:fetch_later`
}
