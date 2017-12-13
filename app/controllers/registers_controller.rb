# frozen_string_literal: true

class RegistersController < ApplicationController
  layout 'layouts/default/application'

  def index
    @search = Spina::Register.ransack(params[:q])

    @registers = if params[:phase] == 'ready to use'
                   @search.result.where(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 elsif params[:phase] == 'in progress'
                   @search.result.where.not(register_phase: 'Beta').sort_by_phase_name_asc.by_name
                 else
                   @search.result.sort_by_phase_name_asc.by_name
                 end

    @page = Spina::Page.find_by(name: 'registerspage')
    @current_phases = Spina::Register::CURRENT_PHASES

    # Fetch the register register for each phase and get records
    beta_register_register = @@registers_client.get_register('register', 'beta').get_records
    alpha_register_register = @@registers_client.get_register('register', 'alpha').get_records
    discovery_register_register = @@registers_client.get_register('register', 'discovery').get_records
    @register_registers = beta_register_register.to_a + alpha_register_register.to_a + discovery_register_register.to_a
  end

  def show
    @register = Spina::Register.find_by_slug!(params[:id])
    @register_data = @@registers_client.get_register(@register.name.parameterize, @register.register_phase)

    records =
      case params[:status]
      when 'archived'
        @register_data.get_expired_records
      when 'all'
        @register_data.get_records
      else
        @register_data.get_current_records
      end

    records = params[:sort_by] ? sort_by(records, params[:sort_by], params[:sort_direction]) : records

    records = params[:q] ? search(records, params[:q]) : records

    @records = paginate(records.to_a)
  end

  def info
    @register = Spina::Register.find_by_slug!(params[:id])
  end

  def history
    @register = Spina::Register.find_by_slug!(params[:id])
    @register_data = @@registers_client.get_register(@register.name.parameterize, @register.register_phase)

    fields = @register_data.get_field_definitions.map { |field| field[:item]['field'] }
    all_records = @register_data.get_records_with_history
    entries_reversed = @register_data.get_entries.reverse_each

    entries_mapped_with_items = entries_reversed.map do |entry|
      records_for_key = all_records.get_records_for_key(entry[:key])
      current_record = records_for_key.detect { |record| record[:entry_number] == entry[:entry_number] }
      previous_record_index = records_for_key.find_index(current_record) - 1

      if previous_record_index.negative?
        changed_fields = fields
      else
        previous_record = records_for_key[previous_record_index]
        changed_fields = fields.reject { |f| current_record[:item][f] == previous_record[:item][f] }
      end

      { current_record: current_record, previous_record: previous_record, updated_fields: changed_fields, key: entry[:key] }
    end

    if params[:q].present?
      filtered = filter(entries_mapped_with_items, params[:q])
      @entries_with_items = paginate(filtered)
    else
      @entries_with_items = paginate(entries_mapped_with_items)
    end
  end

private

  def filter(entries, query)
    entries.select do |entry|
      entry[:key].downcase.include?(query.downcase) ||
        contain_value_filtered_by_field_names?(entry[:current_record], entry[:updated_fields], query) ||
        contain_value_filtered_by_field_names?(entry[:previous_record], entry[:updated_fields], query)
    end
  end

  def search(records, query)
    records.select { |r| contain_value?(r, query) }
  end

  def contain_value_filtered_by_field_names?(item, updated_fields, query)
    return false if item.nil?
    item[:item].each do |field_name, field_value|
      next unless updated_fields.include?(field_name)

      return true if contain?(field_name, query)

      return true if include?(field_value, query)
    end

    false
  end

  def contain_value?(item, query)
    return false if item.nil?

    item[:item].values.any? { |value| include?(value, query) }
  end

  def include?(value, query)
    if value.is_a?(String)
      return true if contain?(value, query)
    else
      return true if contain_in_array?(value, query)
    end

    false
  end

  def sort_by(records, sort_by, sort_direction = 'asc')
    records.sort { |a, b|
    a_field_value = a[:item][params[:sort_by]]
    b_field_value = b[:item][params[:sort_by]]
    comparator = sort_direction == 'desc' ?  b_field_value <=> a_field_value : a_field_value <=> b_field_value
    a_field_value && b_field_value ? comparator : a_field_value ? -1 : 1  }
  end

  def contain_in_array?(field_values, request_value)
    field_values.any? { |value| contain?(value, request_value) }
  end

  def contain?(field_value, request_value)
    field_value.downcase.include?(request_value.downcase)
  end

  def paginate(records)
    Kaminari.paginate_array(records).page(params[:page]).per(100)
  end
end
