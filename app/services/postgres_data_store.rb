require 'data_store'

class PostgresDataStore
  include DataStore

  def initialize(register)
    @page_size = 100
    @items = {}
    @entries = { user: [], system: [] }
    @records = { user: {}, system: {} }
    @register = register
  end

  def add_item(item)
    @items[item.hash.to_s] = item
  end

  def append_entry(entry)
    entry_type = entry.entry_type.to_sym
    item = @items[entry.item_hash]
    previous_entry_number = @records[entry_type].has_key?(entry.key) ? @records[entry_type][entry.key].last : nil
    db_entry = Entry.new(spina_register: @register, data: item.value, timestamp: entry.timestamp, hash_value: item.hash, entry_number: entry.entry_number, previous_entry_number: previous_entry_number, entry_type: entry_type, key: entry.key)

    @entries[entry_type] << db_entry

    unless @records[entry_type].key?(entry.key)
      @records[entry_type][entry.key] = []
    end

    @records[entry_type][entry.key] << db_entry
  end

  def get_item(item_hash)
  end

  def get_items
  end

  def get_entry(entry_type, entry_number)
  end

  def get_entries(entry_type)
  end

  def get_record(entry_type, key)
  end

  def get_records(entry_type)
  end

  def get_latest_entry_number(entry_type)
    latest_entry = Entry.where(spina_register_id: @register.id, entry_type: entry_type).order(:entry_number).reverse_order.first
    unless (latest_entry.nil?)
      latest_entry.entry_number
    else
      latest_entry = @entries[entry_type].last
      latest_entry.nil? ? 0 : latest_entry.entry_number
    end
  end

  def after_load
    batch_update(:user)
    batch_update(:system)
    @items.clear
  end

  private

  def batch_update(entry_type)
    if (@entries[entry_type].length > 0)
      @entries[entry_type].each_slice(1000) do |entries|
        Entry.import!(entries)
      end
    end

    if (@records[entry_type].length > 0)
      bulk_remove_existing_records(@register, entry_type, @records[entry_type].keys)

      records = []
      @records[entry_type].each_value do |record_entries|
        entry_for_record = record_entries.last

        records << Record.new(spina_register: @register, data: entry_for_record.data, timestamp: entry_for_record.timestamp, hash_value: entry_for_record.hash_value, entry_number: entry_for_record.entry_number, entry_type: entry_for_record.entry_type, key: entry_for_record.key)
      end

      Record.import!(records)
    end

    @entries[entry_type].clear
    @records[entry_type].clear
  end

  def bulk_remove_existing_records(register, entry_type, record_keys)
    unless record_keys.empty?
      Record.where(spina_register_id: register.id, entry_type: entry_type, key: record_keys).delete_all
    end
  end

  def bulk_save(entries, records)
    Entry.import!(entries)
    Record.import!(records)
  end
end