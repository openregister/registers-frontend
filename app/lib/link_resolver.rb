class LinkResolver
  include ActionView::Helpers::UrlHelper

  def initialize(current_register_slug:, register_whitelist:)
    @current_register_slug = current_register_slug
    @register_whitelist = register_whitelist
    @url_helpers = Rails.application.routes.url_helpers
  end

  def resolve(field, field_value)
    field_register_slug = field['register']
    field_name = field['field']
    field_datatype = field['datatype']

    if field_datatype == 'curie' && field_value.include?(':')
      resolve_curie(field_value)
    elsif field_register_slug.present? && field_name != current_register_slug && register_whitelist.include?(field_register_slug)
      resolve_foreign_key(field_register_slug, field_value)
    elsif field_datatype == 'url'
      link_to(field_value, field_value)
    else
      field_value
    end
  end

private

  attr_reader :current_register_slug
  attr_reader :register_whitelist
  attr_reader :url_helpers

  def resolve_curie(curie)
    curie_register, curie_key = curie.split(':')

    if !register_whitelist.include?(curie_register)
      curie
    elsif curie_key.present?
      link_to(curie, url_helpers.register_record_path(curie_register, curie_key))
    else
      link_to(curie, url_helpers.register_path(curie_register))
    end
  end

  def resolve_foreign_key(register_slug, key)
    link_to(key, url_helpers.register_record_path(register_slug, key))
  end
end
