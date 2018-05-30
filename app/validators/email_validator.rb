class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.match?(/\A(|(([A-Za-z0-9]+_+)|([A-Za-z0-9]+\-+)|([A-Za-z0-9]+\.+)|([A-Za-z0-9]+\++))*[A-Za-z0-9]+@((\w+\-+)|(\w+\.))*\w{1,63}\.[a-zA-Z]{2,})\z/i)
      record.errors[attribute] << 'Enter a valid email address'
    end
  end
end
