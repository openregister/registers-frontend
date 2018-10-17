module ApplicationHelper
  def page_entries_info(collection, options = {})
    raw super(collection, options).gsub(/(\d{4,})/) { |m| number_with_delimiter(m) }
  end

  def crest_class_name(authority)
    case authority
    when 'home-office'
      'logo-with-crest crest-ho'
    when 'ministry-of-defence'
      'logo-with-crest crest-mod'
    when 'hm-revenue-customs'
      'logo-with-crest crest-hmrc'
    when 'department-for-business-innovation-and-skills'
      'logo-with-crest crest-bis'
    when 'the-office-of-the-leader-of-the-house-of-commons'
      'logo-with-crest crest-portcullis'
    when 'office-of-the-advocate-general-for-scotland'
      'logo-with-crest crest-so'
    when 'uk-atomic-energy-authority'
      'logo-with-crest crest-ukaea'
    when 'nhs', 'scottish-government', 'welsh-government', 'office-for-national-statistics'
      ' '
    else
      'logo-with-crest crest-org'
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
end
