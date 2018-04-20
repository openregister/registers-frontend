class RemoveSpinaTables < ActiveRecord::Migration[5.1]
  def change
    drop_table :spina_accounts
    drop_table :spina_attachment_collections
    drop_table :spina_attachment_collections_attachments
    drop_table :spina_attachments
    drop_table :spina_colors
    drop_table :spina_layout_parts
    drop_table :spina_line_translations
    drop_table :spina_lines
    drop_table :spina_media_folders
    drop_table :spina_navigation_items
    drop_table :spina_navigations
    drop_table :spina_options
    drop_table :spina_page_parts
    drop_table :spina_page_translations
    drop_table :spina_pages
    drop_table :spina_photo_collections
    drop_table :spina_photo_collections_photos
    drop_table :spina_photos
    drop_table :spina_rewrite_rules
    drop_table :spina_settings
    drop_table :spina_structure_items
    drop_table :spina_structure_parts
    drop_table :spina_structures
    drop_table :spina_text_translations
    drop_table :spina_texts

    rename_table :spina_users, :users
  end
end
