# frozen_string_literal: true

module Spina
  class RegistersController < Spina::ApplicationController
    helper_method :sort_column, :sort_direction

    before_action :initialize_client

    layout 'layouts/default/application'

    def index
      @search = Spina::Register.ransack(params[:q])

      if params[:phase] == 'ready to use'
        @registers = @search.result.where(register_phase: 'Beta').sort_by_phase_name_asc.by_name
      elsif params[:phase] == 'in progress'
        @registers = @search.result.where.not(register_phase: 'Beta').sort_by_phase_name_asc.by_name
      else
        @registers = @search.result.sort_by_phase_name_asc.by_name
      end

      @page = Spina::Page.find_by(name: 'registerspage')
      @current_phases = Spina::Register::CURRENT_PHASES

      # Fetch the register register for each phase and get records
      beta_register_register = @@registers_client.get_register('register', 'beta').get_records
      alpha_register_register = @@registers_client.get_register('register', 'alpha').get_records
      discovery_register_register = @@registers_client.get_register('register', 'discovery').get_records
      @register_registers = beta_register_register + alpha_register_register + discovery_register_register
    end

    def show
      @register = Spina::Register.find_by_slug!(params[:id])
      @register_data = @@registers_client.get_register(@register.name.parameterize, @register.register_phase)

      records =
        case params[:status]
          when 'closed'
            @register_data.get_expired_records
          when 'all'
            @register_data.get_records
          else
            @register_data.get_current_records
        end

      records = search(records, params[:q]) if params[:q]

      @records = paginate(records)
    end

    def info
      @register = Spina::Register.find_by_slug!(params[:id])
    end

    def history
      @register = Spina::Register.find_by_slug!(params[:id])
      @register_data = @@registers_client.get_register(@register.name.parameterize, @register.register_phase)

      fields = @register_data.get_field_definitions.map { |field| field[:item]['field'] }
      all_records = @register_data.get_records_with_history
      entries_reversed = @register_data.get_entries.reverse

      changed_fields = []

      entries_mapped_with_items = entries_reversed.map do |entry|
        records_for_key = all_records[entry[:key]]
        current_record = records_for_key.detect { |record| record[:entry_number] == entry[:entry_number] }
        previous_record_index = records_for_key.find_index(current_record) - 1

        if previous_record_index < 0
          changed_fields = fields
        else
          previous_record = records_for_key[previous_record_index]
          changed_fields = fields.reject { |f| current_record[:item][f] == previous_record[:item][f] }
        end

        { current_record: current_record, previous_record: previous_record, updated_fields: changed_fields, key: entry[:key] }
      end

      if params[:q].present?
        filtered = filter(entries_mapped_with_items, changed_fields, params[:q])
        @entries_with_items = paginate(filtered)
      else
        @entries_with_items = paginate(entries_mapped_with_items)
      end
    end

    private

    def filter(entries, updated_fields, query)
      entries.select do |entry|
        entry[:key].downcase.include?(query.downcase) ||
          if updated_fields.nil?
            contained?(entry[:current_record], query)
          else
            contained_with_fields?(entry[:current_record], updated_fields, query)
          end
      end
    end

    def search(records, query)
      records.select { |r| contained?(r, query) }
    end

    def contained_with_fields?(item, updated_fields, query)
      return false if item.nil?

      item[:item].each do |key, value|
        next unless updated_fields.include?(key)

        if value.is_a?(String)
          return true if included_in_cardinality_1?(value, query)
        else
          return true if included_in_cardinality_n?(value, query)
        end
      end

      false
    end

    def contained?(item, query)
      return false if item.nil?

      item[:item].each do |fields|
        fields.each do |field_value|
          if field_value.is_a?(String)
            return true if included_in_cardinality_1?(field_value, query)
          else
            return true if included_in_cardinality_n?(field_value, query)
          end
        end
      end

      false
    end

    def included_in_cardinality_n?(field_values, request_value)
      field_values.each do |field_value|
        return true if included_in_cardinality_1?(field_value, request_value)
      end

      false
    end

    def included_in_cardinality_1?(field_value, request_value)
      field_value.downcase.include?(request_value.downcase)
    end

    def initialize_client
      @@registers_client ||= RegistersClient::RegistersClientManager.new(cache_duration: 600)
    end

    def paginate(records)
      Kaminari.paginate_array(records).page(params[:page]).per(100)
    end
  end
end
