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
    Date.parse(date).strftime('%d/%m/%Y') # eg 03/08/2015
  end

  def human_readable_date(date)
    Date.parse(date).strftime('%e %B %Y') # eg 3 August 2015
  end

  def records_table_header(field_value)
    wrapper_css_class = params[:sort_by] == field_value ? 'table-header active' : 'table-header'
    what_does_this_mean = content_tag('span', "What does #{field_value} mean", class: 'visually-hidden') + '?'

    content_tag 'th', class: "#{field_value} #{wrapper_css_class}" do
      content_tag('span', field_value.tr('-', ' ').humanize) +
        link_to(what_does_this_mean, register_field_url(@register.slug, field_value), class: 'info-icon', remote: true, data: { "click-events" => true, "click-category" => "Register Table", "click-action" => "Help" })
    end
  end
end
