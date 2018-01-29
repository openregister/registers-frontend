require 'data_store'

class PostgresDataStore
  include DataStore

  def initialize(register)
    @page_size = 100
    @items = {}
    @entries = { user: [], system: [] }
    @records = { user: {}, system: {} }
    @register = register
    @has_existing_entries_in_db = Entry.where(spina_register_id: @register.id).exists?
  end

  def add_item(item)
    @items[item.hash.to_s] = item
  end

  def append_entry(entry)
    entry_type = entry.entry_type.to_sym
    item = @items[entry.item_hash]
    previous_entry_number_from_memory = @records[entry_type].key?(entry.key) ? @records[entry_type][entry.key].last[:entry_number] : nil

    previous_entry_number_from_db =
    if @has_existing_entries_in_db
      latest_entry_from_db = Entry.where(spina_register_id: @register.id, entry_type: entry.entry_type.to_s, key: entry.key.to_s).order(entry_number: :desc).first
      latest_entry_from_db ? latest_entry_from_db[:entry_number] : nil
    else
      nil
    end
    
    previous_entry_number = previous_entry_number_from_memory || previous_entry_number_from_db

    db_entry = Entry.new(spina_register: @register, data: item.value, timestamp: entry.timestamp, hash_value: item.hash, entry_number: entry.entry_number, previous_entry_number: previous_entry_number, entry_type: entry_type, key: entry.key)

    @entries[entry_type] << db_entry

    unless @records[entry_type].key?(entry.key)
      @records[entry_type][entry.key] = []
    end

    @records[entry_type][entry.key] << db_entry
    end


  def get_item(item_hash); end

  def get_items; end

  def get_entry(entry_type, entry_number); end

  def get_entries(entry_type); end

  def get_record(entry_type, key); end

  def get_records(entry_type); end

  def get_latest_entry_number(entry_type)
    latest_entry = Entry.where(register_id: @register.id, entry_type: entry_type).order(:entry_number).reverse_order.first
    if latest_entry.nil?
      latest_entry = @entries[entry_type].last
      latest_entry.nil? ? 0 : latest_entry.entry_number
    else
      latest_entry.entry_number
    end
  end

  def after_load
    batch_update(:user)
    batch_update(:system)
    @items.clear
  end

private

  def batch_update(entry_type)
    begin
      latest_entry = Entry.where(register_id: @register.id, entry_type: entry_type).order(:entry_number).reverse_order.first

      if !@entries[entry_type].empty?
        @entries[entry_type].each_slice(1000) do |entries|
          Entry.transaction do
            Entry.import!(entries)
          end
        end
      end

      if !@records[entry_type].empty?
        Record.transaction do
          bulk_remove_existing_records(@register, entry_type, @records[entry_type].keys)
        end

        @records[entry_type].each_slice(1000) do |records|
          records_to_add = []
          records.each do |record|
            entry_for_record = record[1].last

            records_to_add << Record.new(register: @register, data: entry_for_record.data, timestamp: entry_for_record.timestamp, hash_value: entry_for_record.hash_value, entry_number: entry_for_record.entry_number, entry_type: entry_for_record.entry_type, key: entry_for_record.key)
          end

          Record.import!(records_to_add)
        end
      end

      @entries[entry_type].clear
      @records[entry_type].clear
    rescue StandardError => e
      Delayed::Worker.logger.error("Problem found populating #{@register.name}: #{e.message}")

      if latest_entry.nil?
        Record.destroy_all(register_id: @register.id)
        Entry.destroy_all(register_id: @register.id)
      else
        Record.where(register_id: @register.id).where("entry_number > #{latest_entry.entry_number}").destroy_all
        Entry.where(register_id: @register.id).where("entry_number > #{latest_entry.entry_number}").destroy_all
      end
      raise StandardError.new('PopulationError')
    end
  end

  def bulk_remove_existing_records(register, entry_type, record_keys)
    unless record_keys.empty?
      Record.where(register_id: register.id, entry_type: entry_type, key: record_keys).delete_all
    end
  end

  def bulk_save(entries, records)
    Entry.import!(entries)
    Record.import!(records)
  end
end
