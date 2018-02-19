require 'data_store'

class PostgresDataStore
  include DataStore
  EMPTY_ROOT_HASH = 'sha-256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855'.freeze

  def initialize(register)
    @page_size = 100
    @items = {}
    @entries = { user: [], system: [] }
    @records = { user: {}, system: {} }
    @register = register
    @has_existing_entries_in_db = Entry.where(register_id: @register.id).exists?
  end

  def add_item(item)
    @items[item.hash.to_s] = item
  end

  def append_entry(entry)
    entry_type = entry.entry_type.to_sym
    item = @items[entry.item_hash]
    db_entry = Entry.new(register: @register, data: item.value, timestamp: entry.timestamp, hash_value: item.hash, entry_number: entry.entry_number, previous_entry_number: get_previous_entry_number(entry), entry_type: entry_type, key: entry.key)

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
    @has_existing_entries_in_db = Entry.where(register_id: @register.id).exists?
  end

  def set_root_hash(root_hash)
    @register.root_hash = root_hash
  end

  def get_root_hash
    @register.root_hash ? @register.root_hash : EMPTY_ROOT_HASH
  end

private

  def get_previous_entry_number(entry)
    entry_type = entry.entry_type.to_sym
    existing_latest_entry_for_key =
      if @has_existing_entries_in_db
        @records[entry_type].key?(entry.key) ? @records[entry_type][entry.key].last : Record.find_by(register_id: @register.id, entry_type: entry.entry_type.to_s, key: entry.key.to_s)
      else
        @records[entry_type].key?(entry.key) ? @records[entry_type][entry.key].last : nil
      end

    previous_entry_number =
      unless existing_latest_entry_for_key.nil?
        existing_latest_entry_for_key[:entry_number]
      end

    previous_entry_number
  end

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
