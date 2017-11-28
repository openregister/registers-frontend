module Spina
  class RegistersController < Spina::ApplicationController
    helper_method :sort_column, :sort_direction

    before_action :initialize_client

    layout "layouts/default/application"

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

    def new_show
      @register = Spina::Register.find_by_slug!(params[:id])
      @register_data = @@registers_client.get_register(@register.name.parameterize, @register.register_phase)

      if params[:status]
        case params[:status]
          when 'closed'
            @records = @register_data.get_expired_records
          when 'current'
            @records = @register_data.get_current_records
          when 'all'
            @records = @register_data.get_records
        end
      else
        @records = @register_data.get_current_records
      end
    end

    def show
      @register = Spina::Register.find_by_slug!(params[:id])
    end

    def history
      @register = Spina::Register.find_by_slug!(params[:id])
      @register_data = @@registers_client.get_register(@register.name.parameterize, @register.register_phase)

      fields = @register_data.get_field_definitions.map { |field| field[:item]['fields'] }
      all_records = @register_data.get_records_with_history
      entries_reversed = @register_data.get_entries.reverse

      @entries_with_items = entries_reversed.map { |entry|
        records_for_key = all_records[entry[:key]]
        current_record = records_for_key.detect { |record| record[:entry_number] == entry[:entry_number] }
        previous_record_index = records_for_key.find_index(current_record) - 1

        if previous_record_index < 0
          changed_fields = fields
        else
          previous_record = records_for_key[previous_record_index]
          changed_fields = fields.select { |f| current_record[:item][f] != previous_record[:item][f] }
        end

        { current_record: current_record, previous_record: previous_record, updated_fields: changed_fields, key: entry[:key] }
      }

      filter(params[:search_input]) unless params[:search_input].nil?
    end

    private

    def filter(filter_value)
      @entries_with_items = @entries_with_items.select { |entry|
        entry[:key].downcase.include?(filter_value.downcase) ||
          contained?(entry[:previous_record], filter_value) ||
          contained?(entry[:current_record], filter_value)
      }
    end

    def contained?(item, request_value)
      return false if item.nil?

      item[:item].each { |fields|
        fields.each do |field_value|
          if field_value.is_a?(String)
            return true if include_in_card_1?(field_value, request_value)
          else
            return true if include_in_card_n?(field_value, request_value)
          end
        end
      }

      false
    end

    def include_in_card_n?(field_values, request_value)
      field_values.each { |field_value|
        return true if include_in_card_1?(field_value, request_value)
      }

      false
    end

    def include_in_card_1?(field_value, request_value)
      field_value.downcase.include?(request_value.downcase)
    end

    def initialize_client
      @@registers_client ||= RegistersClient::RegistersClientManager.new({ cache_duration: 600 })
    end
  end
end
