class OdsSerialiseJob < ApplicationJob
  # Usage: rails r "OdsSerialiseJob.perform_now('school-eng')"
  queue_as :default

  def perform(register_slug)
    register = Register.find_by(slug: register_slug)
    fields_array = register.fields_array
    headers = fields_array
    data = register.records.where(entry_type: 'user').find_each.map { |r|
      fields_array.map { |f| r.data[f] }
    }

  # we are just writing to disk here as a demo but we would write to S3 or return as a response to the user
    File.open("#{register_slug}.ods", 'w+b') do |f|
      f.write SpreadsheetArchitect.to_ods(headers: headers, data: data)
    end
  end
end
