module Search
  extend ActiveSupport::Concern

  def search(records, query)
    records.select { |r| contain_value?(r.item, query) }
  end

  def contain_value_filtered_by_field_names?(record, updated_fields, query)
    return false if record.nil?
    record.data.each do |field_name, field_value|
      next unless updated_fields.include?(field_name)

      return true if contain?(field_name, query)

      return true if include?(field_value, query)
    end

    false
  end

  def contain_value?(item, query)
    return false if item.nil?

    item.value.values.any? { |value| include?(value, query) }
  end

  def include?(value, query)
    if value.is_a?(String)
      value.downcase.include?(query.downcase)
    else
      value.any? { |v| contain?(v, query) }
    end
  end

  def contain_in_array?(field_values, request_value)
    field_values.any? { |value| contain?(value, request_value) }
  end

  def contain?(field_value, request_value)
    field_value.downcase.include?(request_value.downcase)
  end

  def filter(entries, query)
    entries.select do |entry|
      entry[:key].downcase.include?(query.downcase) ||
        contain_value_filtered_by_field_names?(entry[:current_record], entry[:updated_fields], query) ||
        contain_value_filtered_by_field_names?(entry[:previous_record], entry[:updated_fields], query)
    end
  end
end
