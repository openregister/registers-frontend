module ApplicationHelper
  include ActionView::Helpers::UrlHelper
  
  def crest_class_name(authority)
    case authority
    when "home-office"
      "logo-with-crest crest-ho"
    when "ministry-of-defence"
      "logo-with-crest crest-mod"
    when "hm-revenue-customs"
      "logo-with-crest crest-hmrc"
    when "department-for-business-innovation-and-skills"
      "logo-with-crest crest-bis"
    when "the-office-of-the-leader-of-the-house-of-commons"
      "logo-with-crest crest-portcullis"
    when "office-of-the-advocate-general-for-scotland"
      "logo-with-crest crest-so"
    when "uk-atomic-energy-authority"
      "logo-with-crest crest-ukaea"
    when "nhs", "government-digital-service", "scottish-government", "welsh-government"
      " "
    else
      "logo-with-crest crest-org"
    end
  end

  def phase_label(phase)
    case phase
    when 'Beta'
      'Ready to use'
    when 'Alpha'
      'Open for feedback'
    when 'Discovery'
      'In the backlog'
    when 'Backlog'
      'In the backlog'
    end
  end

  def formatted_date(date)
    Date.parse(date).strftime('%d/%m/%Y')
  end

  def records_table_sort_link(field_value, query_parameters)
    direction = params[:sort_direction] == 'asc' && params[:sort_by] == field_value ? 'desc' : 'asc'
    css_class = params[:sort_by] == field_value ? "sort-link #{params[:sort_direction]}" : "sort-link"
    wrapper_css_class = params[:sort_by] == field_value ? 'sort-link-th active' : 'sort-link-th'

    content_tag 'div', class: wrapper_css_class do
      link_to field_value.tr('-', ' ').humanize, register_path(@register.slug,
                                                 query_parameters.except(:sort_by, :sort_direction)
                                                 .to_h.merge(sort_direction: direction,
                                                 sort_by: field_value,
                                                 anchor: 'search_wrapper')),
                                                 class: css_class
    end
  end

  def field_link_resolver(field, field_value, register_slug = @register.slug)
    single_resolver = lambda { |f, fv|
      if f['datatype'] == 'curie' && fv.include?(':')
        curie = fv.split(':')
        curie[1].present? ? link_to(fv, register_record_path(curie[0], curie[1])) : link_to(fv, register_path(register_slug))
      elsif f['register'].present? && f['field'] != register_slug
        link_to(fv, register_record_path(f['register'], fv))
      elsif f['datatype'] == 'url'
        link_to(fv, fv)
      else
        fv
      end
    }

    cardinality_n_links = -> { field_value.map { |fv| single_resolver.call(field, fv) }.join(', ').html_safe }

    field_value.is_a?(Array) ? cardinality_n_links.call : single_resolver.call(field, field_value)
  end

end
